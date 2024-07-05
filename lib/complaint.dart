import 'package:flutter/material.dart';
import 'resident.dart';
import 'Contact.dart';
import 'profile.dart';
import 'food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  TextEditingController _complaintController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _roomNoController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _complaintController.dispose();
    _nameController.dispose();
    _roomNoController.dispose();
    super.dispose();
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
        padding: const EdgeInsets.all(16.0), // Added padding to body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Complaints',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.collection('complaints').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final complaints = snapshot.data!.docs;
                  complaints.sort((a, b) => b.data()['timestamp'].compareTo(a.data()['timestamp']));
                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final complaintData = complaints[index].data();
                      final complaint = complaintData['complaint'];
                      final status = complaintData['status'] ?? 'Pending'; // Default to Pending
                      final complaintId = complaints[index].id;
                      final name = complaintData['name'];
                      final roomNo = complaintData['roomNo'];

                      return Dismissible(
                        key: Key(complaintId),
                        onDismissed: (direction) {
                          _deleteComplaint(complaintId);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: _buildComplaintRow(
                          complaint,
                          status,
                          complaintId,
                          context,
                          name,
                          roomNo,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Complaint Box and Submit Button at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Room No. Field
                  TextFormField(
                    controller: _roomNoController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Room No.',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Complaint Field
                  TextFormField(
                    controller: _complaintController,
                    decoration: InputDecoration(
                      hintText: 'Enter your complaint',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      // Submit complaint to Firestore
                      _firestore.collection('complaints').add({
                        'complaint': _complaintController.text,
                        'status': 'Pending',
                        'timestamp': DateTime.now(),
                        'name': _nameController.text, // Store name
                        'roomNo': _roomNoController.text, // Store roomNo
                      }).then((value) => print("Complaint submitted"))
                          .catchError((error) => print("Failed to submit: $error"));

                      // Clear text fields after submit
                      _complaintController.text = "";
                      _nameController.text = "";
                      _roomNoController.text = "";
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(128, 76, 3, 145),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
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
                // Navigate to profile section
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => resident()),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile
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
                  MaterialPageRoute(builder: (context) => const FoodMenuPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Complaints'),
              selected: true,
              tileColor: Colors.grey[200],
              onTap: null,
            ),
            ListTile(
              title: const Text('Contact Details'),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OwnerDetailsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintRow(
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

  void _deleteComplaint(String complaintId) {
    _firestore.collection('complaints').doc(complaintId).delete();
  }
}