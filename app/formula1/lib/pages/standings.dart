import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConstructorsStandingsPage extends StatefulWidget {
  const ConstructorsStandingsPage({Key? key}) : super(key: key);

  @override
  ConstructorsStandingsPageState createState() => ConstructorsStandingsPageState();
}

class ConstructorsStandingsPageState extends State<ConstructorsStandingsPage> {
  late List<dynamic> _constructorStandings = [];
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _fetchConstructorStandings();
  }

  Future<void> _fetchConstructorStandings() async {
    final response = await http.get(Uri.parse('https://ergast.com/api/f1/$_selectedYear/constructorStandings.json'));
    if (response.statusCode == 200) {
      setState(() {
        _constructorStandings = jsonDecode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'];
      });
    } else {
      throw Exception('Failed to load constructor standings');
    }
  }

  Widget _title() {
    return const Text(
      'Constructor Standings',
      style: TextStyle(
        fontFamily: 'F1',
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }

  Widget _yearDropdown() {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(currentYear - 1957, (index) => currentYear - index);

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
            _fetchConstructorStandings();
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

  Widget _constructorStandingsList() {
    if (_constructorStandings.isEmpty) {
      return const Text('Loading constructor standings...');
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _constructorStandings.length,
        itemBuilder: (BuildContext context, int index) {
          final constructorStanding = _constructorStandings[index];
          final constructor = constructorStanding['Constructor'];

          return Card(
            child: ListTile(
              leading: Text('${constructorStanding['position']} .', style: const TextStyle(fontFamily: 'F1')),
              title: Text(constructor['name'], style: const TextStyle(fontFamily: 'F1')),
              trailing: Text('PTS: ${constructorStanding['points']}', style: const TextStyle(fontFamily: 'F1')),
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
            _constructorStandingsList(),
          ],
        ),
      ),
    );
  }
}
