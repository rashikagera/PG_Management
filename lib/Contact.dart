import 'package:flutter/material.dart';
import 'resident.dart';
import 'profile.dart';
import 'complaint.dart';
import 'food.dart';

class OwnerDetailsPage extends StatelessWidget {
  const OwnerDetailsPage({Key? key}) : super(key: key);

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
              width: 80, // Reduced image width
              height: 100, // Reduced image height
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding( // Add padding to the body
            padding: const EdgeInsets.all(20), // Adjust padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text(
                      'Owner Details',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 160, // Reduced image container width
                          height: 160, // Reduced image container height
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/owner.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 20.0),
                        ),
                      ),

                      Text(
                        'Owner Name: John Doe',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Age: 55',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mobile Number: 0987654321',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mobile Number(Alternative): 1234567890',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Residential Address: 123 Main Street, City, Country',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email Address: john.doe@example.com',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'All Co-Workers:',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '1. Ramesh - Work: Cook',
                        style: const TextStyle(fontSize: 20), // Reduced font size
                      ),
                      Text(
                        '2. Suresh - Work: Cleaning',
                        style: const TextStyle(fontSize: 20), // Reduced font size
                      ),
                      Text(
                        '3. Mahesh - Work: Gardening',
                        style: const TextStyle(fontSize: 20), // Reduced font size
                      ),
                      // Add more CoWorkers as needed
                    ],
                  ),
                ),
                const SizedBox(height: 30), 
              ],
            ),
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
                // Navigate to home page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => resident()),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile page
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
                  MaterialPageRoute(builder: (context) => (ComplaintsPage())),
                );
              },
            ),
            ListTile(
              title: const Text('Contact Details'),
              selected: true, // Set to true to indicate that the item is selected
              tileColor: Colors.grey[200], // Set the background color to light grey
              onTap: null,
            
            ),
          ],
        ),
      ),
    );
  }
}
