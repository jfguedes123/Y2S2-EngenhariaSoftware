import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverStandingsPage extends StatefulWidget {
  const DriverStandingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DriverStandingsPageState createState() => _DriverStandingsPageState();
}

class _DriverStandingsPageState extends State<DriverStandingsPage> {
  late List<dynamic> _driverStandings = [];
  late int _selectedYear;


  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _fetchDriverStandings(_selectedYear);
  }


  Future<void> _fetchDriverStandings(int year) async {
    final response = await http.get(Uri.parse('https://ergast.com/api/f1/$year/driverStandings.json'));
    if (response.statusCode == 200) {
      setState(() {
        _driverStandings = jsonDecode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'];
      });
    } else {
      throw Exception('Failed to load driver standings');
    }
  }

  Widget _yearDropdown() {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(currentYear - 1949, (index) => currentYear - index);

    return Container(
      width: 365,
      decoration: BoxDecoration(
        color: Colors.red, // Set the container background color to red
        borderRadius: BorderRadius.circular(8.0), // Apply border radius to the container
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: _selectedYear,
        onChanged: (int? newValue) {
          setState(() {
            _selectedYear = newValue!;
            _fetchDriverStandings(_selectedYear);
          });
        },
        items: years.map((int year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text(year.toString(), style: const TextStyle(fontFamily: 'F1', color: Colors.white)),
          );
        }).toList(),
        dropdownColor: Colors.red, // Set the dropdown background color to white
        style: const TextStyle(color: Colors.black), // Set the dropdown text color to black
        underline: Container(), // Remove the default underline
        isExpanded: true, // Expand the dropdown button width
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Driver Standings',
      style: TextStyle(
        fontFamily: 'F1',
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }

  Widget _driverStandingsList() {
    if (_driverStandings.isEmpty) {
      return const Text('Loading driver standings...');
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _driverStandings.length,
        itemBuilder: (BuildContext context, int index) {
          final driverStanding = _driverStandings[index];
          final driver = driverStanding['Driver'];
          final constructor = driverStanding['Constructors'][0];

          return Card(
            child: ListTile(
              leading: Text('${driverStanding['position']} .', style: const TextStyle(fontFamily: 'F1'),),
              title: Text('${driver['givenName']} ${driver['familyName']}', style: const TextStyle(fontFamily: 'F1'),),
              subtitle: Text(constructor['name'], style: const TextStyle(fontFamily: 'F1'),),
              trailing: Text('PTS: ${driverStanding['points']}', style: const TextStyle(fontFamily: 'F1'),),
            ),
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
            _yearDropdown(),
            const SizedBox(height: 20),
            _driverStandingsList(),
          ],
        ),
      ),
    );
  }
}
