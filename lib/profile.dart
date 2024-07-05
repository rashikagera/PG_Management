import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'resident.dart';
import 'Contact.dart';
import 'complaint.dart';
import 'food.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool isEditing = false;

  // TextEditingControllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pgNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _guardianPhoneController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController(); // Room No.

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
          // Initialize TextEditingControllers with fetched data
          _nameController.text = userData!['name'];
          _emailController.text = userData!['email'];
          _phoneController.text = userData!['phone'];
          _pgNameController.text = userData!['pgName'];
          _addressController.text = userData!['address'];
          _guardianPhoneController.text = userData!['guardianPhone'];
          _roomNoController.text = userData!['roomNo'] ?? ''; // Initialize roomNo if it's null
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'pgName': _pgNameController.text,
          'address': _addressController.text,
          'guardianPhone': _guardianPhoneController.text,
          'roomNo': _roomNoController.text,
        });
        setState(() {
          isEditing = false;
          // Re-fetch data after updating
          _fetchUserData();
        });
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated!')),
        );
      } catch (e) {
        print('Error updating user data: ${e.toString()}');
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile. Please try again.')),
        );
      }
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (userData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileField(
                            'Name', _nameController, isEditing, 'name'),
                        const Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        _buildProfileField(
                            'Email', _emailController, isEditing, 'email'),
                        const Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        _buildProfileField(
                            'Phone Number', _phoneController, isEditing, 'phone'),
                        const Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        _buildProfileField(
                            'PG Name', _pgNameController, isEditing, 'pgName'),
                        const Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        _buildProfileField(
                            'Address', _addressController, isEditing, 'address'),
                        const Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        _buildProfileField('Guardian\'s Phone Number',
                            _guardianPhoneController, isEditing, 'guardianPhone'),
                        const Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        _buildProfileField(
                            'Room No.', _roomNoController, isEditing, 'roomNo'),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                )
              else
                CircularProgressIndicator(),
              // Edit/Save Buttons outside the Container
              if (!isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: SizedBox(
                      width: 130,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                  ),
                ),
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateUserData();
                        },
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
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
                  MaterialPageRoute(builder: (context) => (resident())),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              selected: true,
              tileColor: Colors.grey[200],
              onTap: null,
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
                  MaterialPageRoute(builder: (context) => (ComplaintsPage())),
                );
              },
            ),
            ListTile(
              title: const Text('Contact Details'),
              onTap: () {
                // Navigate to contact details page (if needed)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (OwnerDetailsPage())),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
      String label, TextEditingController controller, bool isEditing, String field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), 
        ),
        if (isEditing)
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
            ),
          )
        else
          Text(
            controller.text.isEmpty ? 'Add $label' : controller.text,
            style: const TextStyle(fontSize: 20), 
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}