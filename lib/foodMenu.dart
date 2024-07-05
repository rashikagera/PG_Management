import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'owner.dart';
import 'residentInfo.dart';
import 'notificationOwner.dart';


class UpdateMenuPage extends StatefulWidget {
  const UpdateMenuPage({Key? key}) : super(key: key);

  @override
  _UpdateMenuPageState createState() => _UpdateMenuPageState();
}

class _UpdateMenuPageState extends State<UpdateMenuPage> {
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<String> _pickImage(XFile image) async {
    final ref = FirebaseStorage.instance.ref('menu_images').child('menu_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(File(image.path));
    final url = await ref.getDownloadURL();
    return url;
  }

  void _submit() async {
    if (_imageUrl != null) {
      final uploadedUrl = await _pickImage(_picker.pickImage(source: ImageSource.gallery) as XFile);
      setState(() {
        _imageUrl = uploadedUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully uploaded!')),
      );
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
      body: Padding( // Add padding to the body
        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Update Menu',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _imageUrl == null
                      ? Icon(Icons.camera_alt, size: 100, color: Colors.grey)
                      : Image.network(_imageUrl!),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _imageUrl = image.path;
                    });
                  }
                },
                child: Text('Choose Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(158, 38, 0, 76),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(158, 38, 0, 76),
                  foregroundColor: Colors.white,
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
                  MaterialPageRoute(builder: (context) => owner()),
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
              title: const Text('Notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Resident\'s Detail'),
              onTap: () {
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
}