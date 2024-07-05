import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'owner.dart';
import 'residentInfo.dart';
import 'foodMenu.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _complaintsStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _breakfastStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _lunchStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _dinnerStream;
  int _breakfastCount = 0;
  int _lunchCount = 0;
  int _dinnerCount = 0;
  int _originalResidentCount = 2; // Store the initial count of residents
  int _pendingComplaintsCount = 0; // Variable to store the pending complaints count

  @override
  void initState() {
    super.initState();
    _complaintsStream = _firestore.collection('complaints').snapshots();
    _breakfastStream = _firestore.collection('meals').doc('Breakfast').snapshots();
    _lunchStream = _firestore.collection('meals').doc('Lunch').snapshots();
    _dinnerStream = _firestore.collection('meals').doc('Dinner').snapshots();

    // Listen to changes in the complaints collection
    _complaintsStream.listen((snapshot) {
      // Calculate the number of pending complaints
      _pendingComplaintsCount = snapshot.docs.where((doc) => doc['status'] == 'Pending').length;
      setState(() {}); // Update the UI
    });
  }

  Future<void> _resetCountsFromMeals() async {
    try {
      final breakfastDoc = await _firestore.collection('meals').doc('Breakfast').get();
      final lunchDoc = await _firestore.collection('meals').doc('Lunch').get();
      final dinnerDoc = await _firestore.collection('meals').doc('Dinner').get();
      setState(() {
        _breakfastCount = breakfastDoc.data()?['count'] ?? 0;
        _lunchCount = lunchDoc.data()?['count'] ?? 0;
        _dinnerCount = dinnerDoc.data()?['count'] ?? 0;
      });
    } catch (e) {
      print('Error resetting counts from meals collection: $e');
    }
  }

  Future<void> _updateMealCountsInFirestore() async {
    try {
      await _firestore.collection('meals').doc('Breakfast').update({'count': _originalResidentCount});
      await _firestore.collection('meals').doc('Lunch').update({'count': _originalResidentCount});
      await _firestore.collection('meals').doc('Dinner').update({'count': _originalResidentCount});
    } catch (e) {
      print('Error updating meal counts in Firestore: $e');
    }
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
      body: Padding( // Add padding to the body
        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Meal Blocks
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _breakfastStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      _breakfastCount = snapshot.data!.data()?['count'] ?? 0;
                      return _buildMealBlock('Breakfast', _breakfastCount);
                    },
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _lunchStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      _lunchCount = snapshot.data!.data()?['count'] ?? 0;
                      return _buildMealBlock('Lunch', _lunchCount);
                    },
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _dinnerStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      _dinnerCount = snapshot.data!.data()?['count'] ?? 0;
                      return _buildMealBlock('Dinner', _dinnerCount);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _complaintsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final complaints = snapshot.data!.docs;
                  // Sort complaints in descending order of timestamp (newest first)
                  complaints.sort((a, b) => b.data()['timestamp'].compareTo(a.data()['timestamp']));

                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final complaintData = complaints[index].data();
                      final complaint = complaintData['complaint'];
                      final status = complaintData['status'] ?? 'Pending'; // Default to Pending
                      final complaintId = complaints[index].id;
                      final name = complaintData['name'] ?? ''; // Get name from complaint data
                      final roomNo = complaintData['roomNo'] ?? ''; // Get roomNo from complaint data

                      return _buildNotificationRow(
                        complaint,
                        status,
                        complaintId,
                        context,
                        name,
                        roomNo,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: _updateMealCountsInFirestore, // Call the update function
                  child: Text('Reset'),
                ),
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
              title: Row(
                children: [
                  const Text('Notifications'),
                  const SizedBox(width: 10), // Add some space
                  // Display the number of pending complaints
                  if (_pendingComplaintsCount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red, // Set the background color
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Text(
                        _pendingComplaintsCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
              selected: true, // Set to true to indicate that the item is selected
              tileColor: Colors.grey[200], // Set the background color to light grey
              onTap: null,
            ),
            ListTile(
              title: const Text('Resident\'s Detail'),
              onTap: () {
                // Navigate to complaints
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResidentsInformationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealBlock(String mealName, int count) {
    return Column(
      children: [
        Text(
          mealName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Total: $count',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildNotificationRow(
    String complaint,
    String status,
    String complaintId,
    BuildContext context,
    String name,
    String roomNo,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10), // Adjust the spacing as needed
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        _buildStatusIndicator(status),
                        SizedBox(height: 5),
                        Text('From: $name (Room: $roomNo)', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Update complaint status to "Reviewed" in Firestore
                      _firestore
                          .collection('complaints')
                          .doc(complaintId)
                          .update({'status': 'Reviewed'})
                          .then((value) => print("Complaint status updated"))
                          .catchError((error) => print("Failed to update status: $error"));
                    },
                    child: Text('Reviewed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(128, 76, 3, 145),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Delete the complaint from Firestore
                    _firestore
                        .collection('complaints')
                        .doc(complaintId)
                        .delete()
                        .then((value) => print("Complaint deleted"))
                        .catchError((error) => print("Failed to delete: $error"));
                  },
                  icon: Icon(Icons.close),
                ),
                SizedBox(width: 10), // Adjust the spacing as needed
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color indicatorColor;
    switch (status) {
      case 'Pending':
        indicatorColor = Colors.yellow;
        break;
      case 'Reviewed':
        indicatorColor = Colors.green;
        break;
      default:
        indicatorColor = Colors.grey;
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: indicatorColor,
      ),
    );
  }
}