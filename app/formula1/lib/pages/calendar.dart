import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<dynamic> _races = [];
  int? _sortColumnIndex;
  bool _isAscending = false;
  late dynamic _closestRace = '';
  Duration _dateDifference = const Duration(days: 0);


  @override
  void initState() {
    super.initState();
    _fetchRaces();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => setState((){}));
  }

  Future<void> _fetchRaces() async {
    final response = await http.get(Uri.parse(
        'https://ergast.com/api/f1/current.json'));
    if (response.statusCode == 200) {
      setState(() {
        _races = jsonDecode(response.body)['MRData']['RaceTable']['Races'];
      });
    } else {
      throw Exception('Failed to load races');
    }
  }

  Widget _title() {
    return const Text(
      'Race Calendar',
      style: TextStyle(
        fontFamily: 'F1',
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }


  Widget _raceList() {
    if (_races.isEmpty) {
      return const Text('Loading races...', style: TextStyle(fontFamily: 'F1'),);
    }

    final columns = ['Race', 'Date', 'Circuit'];//, 'Country'];

    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          sortAscending: _isAscending,
          sortColumnIndex: _sortColumnIndex,
          horizontalMargin: 0,
          dataRowHeight: 70,
          columns: _getColumns(columns),
          rows: _getRows(_races),
        ),
      ),
    );
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: _onSort,
          ))
      .toList();

  List<DataRow> _getRows(List<dynamic> races) => races.map((dynamic race) {
    final cells = [race['raceName'], race['date'] + ' ' + race['time'].toString().substring(0, race['time'].toString().indexOf('Z')),
      race['Circuit']['circuitName'] + ' in ' + race['Circuit']['Location']['country']];

    return DataRow(cells: _getCells(cells));
  }).toList();

  List<DataCell> _getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _races.sort((race1, race2) =>
          _compareString(ascending, race1['raceName'], race2['raceName']));
    } else if (columnIndex == 1) {
      _races.sort((race1, race2) =>
          _compareString(ascending, race1['date'] + race1['time'], race2['date'] + race2['time']));
    } else if (columnIndex == 2) {
      _races.sort((race1, race2) =>
          _compareString(ascending, race1['Circuit']['circuitName'] + race1['Circuit']['Location']['country'], race2['Circuit']['circuitName'] + race2['Circuit']['Location']['country']));
    }
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
    });
  }

  int _compareString(bool ascending, String string1, String string2) =>
      ascending ? string1.compareTo(string2) : string2.compareTo(string1);


  void _findNextRace() {
    if (_races.isNotEmpty){
      late dynamic closestRace = '';
      late DateTime dateRace;
      late Duration dateDifference;
      Duration min = const Duration(days: 370);

      for (dynamic race in _races) {
        dateRace = DateTime.parse(race['date'] + 'T' + race['time']);
        dateDifference = dateRace.difference(DateTime.now());

        if (dateDifference > const Duration(seconds: 0) && dateDifference < min) {
          closestRace = race;
          min = dateDifference;
        }
      }
      setState(() {
        _closestRace = closestRace;
        _dateDifference = min;
      });
    }
  }

  Widget _timerCountDown() {
    String raceName = '';
    DateTime dateClosestRace = DateTime(0,0,0);
    if (_closestRace.toString().isNotEmpty) {
      raceName = _closestRace['raceName'];
      dateClosestRace = DateTime.parse(_closestRace['date'] + 'T' + _closestRace['time']);
    }
    String dateRace = dateClosestRace.toString().substring(0, dateClosestRace.toString().length-5);

    if (_dateDifference == const Duration(days: 370)) {
      raceName = 'Next Year';
      dateRace = (DateTime.now().year + 1).toString();
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            '\nNext Race Is $raceName',
            style: const TextStyle(
              fontFamily: 'F1',
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          Text(
            '$dateRace\n',
            style: const TextStyle(
              fontFamily: 'F1',
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          Text(
            _timeRemaining(),
            style: const TextStyle(
              fontFamily: 'F1',
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ]
      )
    );
  }


  String _timeRemaining() {

    _findNextRace();
    if (_dateDifference == const Duration(days: 370)) {
      return 'More Races Next Year.';
    }

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(_dateDifference.inDays);
    final hours = strDigits(_dateDifference.inHours.remainder(24));
    final minutes = strDigits(_dateDifference.inMinutes.remainder(60));
    final seconds = strDigits(_dateDifference.inSeconds.remainder(60));

    return '$days days $hours h $minutes m $seconds s\n';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _timerCountDown(),
            _raceList(),
          ],
        ),
      ),
    );
  }
}