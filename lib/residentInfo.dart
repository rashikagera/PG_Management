import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'owner.dart';
import 'notificationOwner.dart';
import 'foodMenu.dart';

class ResidentsInformationPage extends StatefulWidget {
  const ResidentsInformationPage({Key? key}) : super(key: key);

  @override
  _ResidentsInformationPageState createState() =>
      _ResidentsInformationPageState();
}

class _ResidentsInformationPageState extends State<ResidentsInformationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _residentsStream;

  @override
  void initState() {
    super.initState();
    _residentsStream = _firestore
        .collection('users')
        .where('rool', isEqualTo: 'Resident')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apsora'),
        backgroundColor: const Color.fromARGB(128, 76, 3, 145),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Image.asset(
              "assets/images/hand.png",
              width: 100,
              height: 130,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Resident\'s Information',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold,),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _residentsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final residents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: residents.length,
                    itemBuilder: (context, index) {
                      final residentData = residents[index].data();
                      return _buildResidentRow(residentData);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(128, 76, 3, 145),
              ),
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Navigate to home
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => owner()),
                );
              },
            ),
            ListTile(
              title: const Text('Food Menu'),
              onTap: () {
                // Navigate to food menu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateMenuPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Notifications'),
              onTap: () {
                // Navigate to notifications
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Resident\'s Detail'),
              selected: true,
              tileColor: Colors.grey[200],
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResidentRow(Map<String, dynamic> residentData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
          color: Color.fromARGB(199, 227, 211, 243), // Light purple color
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${residentData['name']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                'Phone Number: ${residentData['phone']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                'Room No.: ${residentData['roomNo'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                'Guardian Phone Number: ${residentData['guardianPhone']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                'Address: ${residentData['address']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}


