import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RaceResultsPage extends StatefulWidget {
  final int year;
  final String circuitName;

  const RaceResultsPage({
    Key? key,
    required this.year,
    required this.circuitName,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RaceResultsPageState createState() => _RaceResultsPageState();
}

class _RaceResultsPageState extends State<RaceResultsPage> {
  late List<dynamic> _raceResults = [];

  @override
  void initState() {
    super.initState();
    _fetchRaceResults();
  }

  Future<void> _fetchRaceResults() async {
    final response = await http.get(Uri.parse(
        'https://ergast.com/api/f1/${widget.year}/circuits/${widget.circuitName}/results.json'));
    if (response.statusCode == 200) {
      setState(() {
        _raceResults = jsonDecode(response.body)['MRData']['RaceTable']['Races'];
      });
    } else {
      throw Exception('Failed to load race results');
    }
  }

  Widget _title() {
    return const Text(
      'Race Results',
      style: TextStyle(
        fontFamily: 'F1',
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }



  Widget _raceResultsList() {
    if (_raceResults.isEmpty) {
      return const Text('Loading race results...', style: TextStyle(fontFamily: 'F1'),);
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _raceResults.length,
        itemBuilder: (BuildContext context, int index) {
          final race = _raceResults[index];
          final driverResults = race['Results'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: ListTile(
                  title: Text(race['raceName'], style: const TextStyle(fontFamily: 'F1'),),
                  subtitle: Text(race['date'], style: const TextStyle(fontFamily: 'F1'),),
                ),
              ),
              ...driverResults.map((driver) => Card(
                child: ListTile(
                  leading: Text('${driver['position']}.', style: const TextStyle(fontFamily: 'F1'),),
                  title: Text('${driver['Driver']['givenName']} ${driver['Driver']['familyName']}', style: const TextStyle(fontFamily: 'F1'),),
                  subtitle: Text('${driver['Constructor']['name']}', style: const TextStyle(fontFamily: 'F1'),),
                  trailing: Text('PTS: ${driver['points']}', style: const TextStyle(fontFamily: 'F1'),),
                ),
              )).toList(),
            ],
          );
        },
      ),
    );
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
            _raceResultsList(),
          ],
        ),
      ),
    );
  }
}
