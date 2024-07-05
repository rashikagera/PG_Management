import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'Contact.dart';
import 'complaint.dart';
import 'food.dart';
import 'LoginSignupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore

class resident extends StatefulWidget {
  const resident({super.key});

  @override
  State<resident> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<resident> {
  final user = FirebaseAuth.instance.currentUser;
  String? userName;
  final _firestore = FirebaseFirestore.instance; // Initialize Firestore

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginSignupPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user's name
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          userName = snapshot.data()?['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apsora PG'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "assets/images/hand.png",
              width: 100,
              height: 90,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Text(
                'Welcome ${userName ?? user!.email}!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Text(
                'Important Announcements',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Display Announcements
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('announcements')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final document = snapshot.data!.docs[index];
                        final announcement = document['announcement'];

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(158, 220, 216, 225),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            announcement,
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(158, 38, 0, 76),
              ),
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              selected: true, // Set to true to indicate that the item is selected
              tileColor: Colors.grey[200], // Set the background color to light grey
              onTap: null, // Disable onTap to make it not clickable
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile section
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Food Menu'),
              onTap: () {
                // Navigate to food menu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodMenuPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Complaints'),
              onTap: () {
                // Navigate to complaints
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (const ComplaintsPage())),
                );
              },
            ),
            ListTile(
              title: const Text('Contact Details'),
              onTap: () {
                // Navigate to contact details page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (const OwnerDetailsPage())),
                );
              },
            ),
            FloatingActionButton(
              onPressed: () {
                logout(context);
              },
              child: Icon(Icons.login_rounded),
            )
          ],
        ),
      ),
    );
  }
}