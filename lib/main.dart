import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pg_management/opening.dart';
import 'package:pg_management/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyBEc87XV5Ipp3nEFvw73MoC8tdCj5wvb0A", appId: '1:948431294245:android:05125e7f2c1b54bee514cc', messagingSenderId: "948431294245", projectId: "pg-management-e23cf"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'APSORA',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF76ABAE, {
            50: Color.fromARGB(128, 76, 3, 145),
            100: Color.fromARGB(128, 76, 3, 145),
            200: Color.fromARGB(128, 76, 3, 145),
            300: Color.fromARGB(128, 76, 3, 145),
            400: Color.fromARGB(128, 76, 3, 145),
            500: Color.fromARGB(128, 76, 3, 145),
            600: Color.fromARGB(128, 76, 3, 145),
            700: Color.fromARGB(128, 76, 3, 145),
            800: Color.fromARGB(128, 76, 3, 145),
            900: Color.fromARGB(128, 76, 3, 145),
          }),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(128, 76, 3, 145),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper()
      );
  }
}