import 'package:flutter/material.dart';
import 'LoginSignupPage.dart';
import 'register.dart';

class OpeningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 208, 189, 211), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add logo here
            Image.asset('assets/images/hand.png', height: 150), 
            SizedBox(height: 20),
            Text(
              'Apsora',
              style: TextStyle(
                fontSize: 58,
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => register(),
                  ),
                );
              },
              child: Text('Register', style: TextStyle(fontSize: 20)), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                textStyle: TextStyle(color: Colors.purple),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20), 
                minimumSize: Size(250, 50), 
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginSignupPage(),
                  ),
                );
              },
              child: Text('Login', style: TextStyle(fontSize: 20)), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                textStyle: TextStyle(color: Colors.purple),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20), 
                minimumSize: Size(250, 50), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}