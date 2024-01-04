import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../auth.dart';
import 'login.dart';

class Ferrari extends StatefulWidget {
  const Ferrari({Key? key}) : super(key: key);

  @override
  State<Ferrari> createState() => _Ferrari();
}

class _Ferrari extends State<Ferrari>{
  late List<dynamic> _races = [];

  @override
  void initState() {
    super.initState();
    _fetchRaces();
  }

  Future<void> _fetchRaces() async {
    final response = await http.get(Uri.parse(
        'http://ergast.com/api/f1/current/constructorStandings.json'));
    if (response.statusCode == 200) {
      setState(() {
        //_races = jsonDecode(response.body)['MRData']['StandingsTable']['StandingsLists'];
        _races = jsonDecode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'];

        //index ira me dizer a equipa
        //print(_races[1]['position']);
        //print(_races[1]['Constructor']['constructorId']);
        //print(_races[1]['Constructor']['nationality']);

      });
    } else {
      throw Exception('Failed to load races');
    }
  }

  Widget _title() {
    return const Text('Ferrari Team');
  }

  Widget _ferrariTeam() {
    return Row(
      children: <Widget>[
        Image.network(
          'https://di-uploads-pod15.dealerinspire.com/lakeforestsportscars/uploads/2021/06/Ferrari-Logo.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(width: 20),
        const Text(
          'Scuderia Ferrari',
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () async {
        await Auth().signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text('Sign Out'),
    );
  }

  Widget _teamInfo() {
    return const ExpansionTile(
      title: Text('Team Info'),
      children: <Widget>[
        ListTile(
          title: Text('Team Name'),
          subtitle: Text('Scuderia Ferrari'),
        ),
        ListTile(
          title: Text('Founded'),
          subtitle: Text('November 16, 1929'),
        ),
        ListTile(
          title: Text('Headquarters'),
          subtitle: Text('Maranello, Italy'),
        ),
      ],
    );
  }

  Widget _teamSponsors() {
    return const ExpansionTile(
      title: Text('Team Sponsors'),
      children: <Widget>[
        ListTile(
          title: Text('Sponsor 1'),
          subtitle: Text('Mission Winnow'),
        ),
        ListTile(
          title: Text('Sponsor 2'),
          subtitle: Text('Shell'),
        ),
        ListTile(
          title: Text('Sponsor 3'),
          subtitle: Text('Ray-Ban'),
        ),
      ],
    );
  }

  Widget _ferrariTeamLineup() {
    return const ExpansionTile(
      title: Text('Ferrari F1 Team Lineup'),
      children: <Widget>[
        ListTile(
          title: Text('Charles Leclerc'),
          subtitle: Text('Driver'),
        ),
        ListTile(
          title: Text('Carlos Sainz Jr.'),
          subtitle: Text('Driver'),
        ),
        ListTile(
          title: Text('Laurent Mekies'),
          subtitle: Text('Sporting Director'),
        ),
        ListTile(
          title: Text('Mattia Binotto'),
          subtitle: Text('Team Principal'),
        ),
      ],
    );
  }

  Widget _teamPersonnel() {
    return const ExpansionTile(
      title: Text('Team Personnel'),
      children: <Widget>[
        ListTile(
          title: Text('Team Principal'),
          subtitle: Text('John Smith'),
        ),
        ListTile(
          title: Text('Technical Director'),
          subtitle: Text('Jane Doe'),
        ),
        ListTile(
          title: Text('Race Engineer'),
          subtitle: Text('Mark Johnson'),
        ),
        ListTile(
          title: Text('Chief Mechanic'),
          subtitle: Text('Sarah Lee'),
        ),
      ],
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
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _ferrariTeam(),
            _teamInfo(),
            _teamSponsors(),
            _ferrariTeamLineup(),
            _teamPersonnel(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}

