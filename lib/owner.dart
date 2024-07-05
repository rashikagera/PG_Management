import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notificationOwner.dart';
import 'foodMenu.dart';
import 'residentInfo.dart';
import 'LoginSignupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore

class owner extends StatefulWidget {
  const owner({super.key});

  @override
  State<owner> createState() => _OwnerState();
}

class _OwnerState extends State<owner> {
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final _announcementController = TextEditingController();

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

  // Function to add an announcement to Firestore
  Future<void> _addAnnouncement(String announcement) async {
    if (announcement.isNotEmpty) {
      await _firestore.collection('announcements').add({
        'announcement': announcement,
        'timestamp': Timestamp.now(),
      });
      _announcementController.clear(); // Clear the text field after adding
    }
  }

  // Function to delete an announcement
  void _deleteAnnouncement(String documentId) {
    _firestore.collection('announcements').doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apsora PG'),
        backgroundColor: const Color.fromARGB(158, 38, 0, 76),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Text(
                  'Welcome Owner!',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(214, 10, 1, 12)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Announcement Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: _announcementController,
                    decoration: InputDecoration(
                      hintText: 'Make an announcement',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _addAnnouncement(_announcementController.text);
                    },
                    child: Text('Announce'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display Announcements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      final docId = document.id;

                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            _deleteAnnouncement(docId); // Delete on tap
                          },
                          icon: Icon(Icons.close),
                        ),
                        title: Text(announcement),
                      );
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
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              // Navigate to home page
              selected: true, // Set to true to indicate that the item is selected
              tileColor: Colors.grey[200], // Set the background color to light grey
              onTap: null,
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
                // Navigate to complaints
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (NotificationsPage())),
                );
              },
            ),
            ListTile(
              title: const Text('Resident\'s Detail'),
              onTap: () {
                // Navigate to complaints
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (ResidentsInformationPage())),
                );
              },
            ),
            FloatingActionButton(
              onPressed: () {
                logout(context);
              },
              child: Icon(Icons.login_rounded),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _announcementController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }
}
