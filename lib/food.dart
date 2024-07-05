import 'package:flutter/material.dart';
import 'resident.dart';
import 'Contact.dart';
import 'complaint.dart';
import 'profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore

class FoodMenuPage extends StatefulWidget {
  const FoodMenuPage({Key? key}) : super(key: key);

  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  String? _imageUrl;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isBreakfastSelected = false;
  bool _isLunchSelected = false;
  bool _isDinnerSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchLatestImage();
  }

  Future<void> _fetchLatestImage() async {
    try {
      final ref = FirebaseStorage.instance.ref('menu_images');
      final listResult = await ref.list();

      // Find the latest image (assuming file names include timestamps)
      String? latestImageUrl;
      DateTime latestTimestamp = DateTime.fromMillisecondsSinceEpoch(0);
      for (final item in listResult.items) {
        final filename = item.name;
        final timestampString = filename.split('_')[1].split('.')[0];
        final timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(timestampString));
        if (timestamp.isAfter(latestTimestamp)) {
          latestTimestamp = timestamp;
          latestImageUrl = await item.getDownloadURL();
        }
      }

      setState(() {
        _imageUrl = latestImageUrl;
      });
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  void _toggleMealSelection(String meal) {
    setState(() {
      switch (meal) {
        case 'Breakfast':
          _isBreakfastSelected = !_isBreakfastSelected;
          break;
        case 'Lunch':
          _isLunchSelected = !_isLunchSelected;
          break;
        case 'Dinner':
          _isDinnerSelected = !_isDinnerSelected;
          break;
      }
      _updateMealCount(meal, _isBreakfastSelected || _isLunchSelected || _isDinnerSelected);
    });
  }

  Future<void> _updateMealCount(String meal, bool isSelected) async {
    try {
      DocumentReference mealDoc = _firestore.collection('meals').doc(meal);
      DocumentSnapshot doc = await mealDoc.get();
      int currentCount = doc.get('count');

      if (isSelected) {
        // Subtract 1 if selected
        await mealDoc.update({'count': currentCount - 1});
      } else {
        // Add 1 if unselected
        await mealDoc.update({'count': currentCount + 1});
      }
    } catch (e) {
      print('Error updating meal count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apsora'),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Food Menu',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                height: 300,
                child: _imageUrl == null
                    ? CircularProgressIndicator() // Show loading while fetching
                    : Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 40),
              // Meal Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _toggleMealSelection('Breakfast'),
                    child: Text('Breakfast'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isBreakfastSelected ? Color.fromARGB(255, 185, 6, 87) : Color.fromARGB(255, 6, 78, 66),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _toggleMealSelection('Lunch'),
                    child: Text('Lunch'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLunchSelected ? Color.fromARGB(255, 185, 6, 87) : Color.fromARGB(255, 6, 78, 66),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _toggleMealSelection('Dinner'),
                    child: Text('Dinner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDinnerSelected ? Color.fromARGB(255, 185, 6, 87) : Color.fromARGB(255, 6, 78, 66),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                color: const Color.fromARGB(158, 38, 0, 76),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => resident()),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Food Menu'),
              selected: true,
              tileColor: Colors.grey[200],
              onTap: null,
            ),
            ListTile(
              title: const Text('Complaints'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintsPage()),
                );
              },
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
}