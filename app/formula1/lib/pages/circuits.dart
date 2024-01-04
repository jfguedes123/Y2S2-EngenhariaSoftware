import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'race_results.dart';

class CircuitsPage extends StatefulWidget {
  const CircuitsPage({Key? key}) : super(key: key);

  @override
  State<CircuitsPage> createState() => _CircuitsPageState();
}

class _CircuitsPageState extends State<CircuitsPage> {
  late int _selectedYear;
  late List<dynamic> _circuits = [];

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _fetchCircuits();
  }

  Future<void> _fetchCircuits() async {
    final response = await http.get(Uri.parse(
        'https://ergast.com/api/f1/$_selectedYear/circuits.json'));
    if (response.statusCode == 200) {
      setState(() {
        _circuits = jsonDecode(response.body)['MRData']['CircuitTable']['Circuits'];
      });
    } else {
      throw Exception('Failed to load circuits');
    }
  }

  Widget _title() {
    return const Text(
      'Circuits',
      style: TextStyle(
        fontFamily: 'F1',
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }

  Widget _yearDropdown() {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(currentYear - 1949, (index) => currentYear - index);

    return Container(
      width: 365,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<int>(
        value: _selectedYear,
        items: years.map((int year) {
          return DropdownMenuItem(
            value: year,
            child: Text(
              year.toString(),
              style: const TextStyle(fontFamily: 'F1', color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (int? value) {
          setState(() {
            _selectedYear = value!;
          });
          _fetchCircuits();
        },
        dropdownColor: Colors.red,
        style: const TextStyle(color: Colors.black),
        underline: Container(),
        isExpanded: true,
      ),
    );
  }

  Widget _circuitList() {
    if (_circuits.isEmpty) {
      return const Text('Loading circuits...', style: TextStyle(fontFamily: 'F1'),);
    }
    // Sort circuits by name
    _circuits.sort((a, b) => a['circuitName'].compareTo(b['circuitName']));

    return Expanded(
      child: ListView.builder(
        itemCount: _circuits.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_circuits[index]['circuitName'], style: const TextStyle(fontFamily: 'F1'),),
              subtitle: Text(_circuits[index]['Location']['country'], style: const TextStyle(fontFamily: 'F1'),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RaceResultsPage(
                      year: _selectedYear,
                      circuitName: _circuits[index]['circuitId'],
                    ),
                  ),
                );
              },
              trailing: const Icon(Icons.keyboard_arrow_right),
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
            _circuitList(),
          ],
        ),
      ),
    );
  }
}