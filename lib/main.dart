import 'package:auth/userPage.dart';
import 'package:auth/error_page.dart';
import 'package:auth/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  Widget pageSwitch(String userType) {
    if (userType == "admin") {
      return const UserPage(userType: "Admin Page");
    } else if (userType == "Hostel student") {
      return const UserPage(userType: "Hostel Student Page");
    } else if (userType == "Hostel Mentor") {
      return const UserPage(userType: "Hostel Mentor Page");
    } else if (userType == "Dayscholar student") {
      return const UserPage(userType: "Day-scholar Student Page");
    } else if (userType == "firstLogin") {
      return const HomePage();
    } else {
      return const KiErrorPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AuthWithout Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: Future(() async {
          var state = await storage.read(key: "userType");
          if (state != null) {
            return state;
          }
          return "firstLogin";
        }),
        initialData: const CircularProgressIndicator(),
        builder: (context, stateSnapshot) {
          if (stateSnapshot.hasData &&
              stateSnapshot.connectionState == ConnectionState.done) {
            return pageSwitch(stateSnapshot.data.toString());
          } else if (stateSnapshot.hasError) {
            print("stateSnapshot.hasError ${stateSnapshot.connectionState}");
            return const KiErrorPage();
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Loading.."),),
              body: const CircularProgressIndicator()
          );
        },
      ),
    );
  }
}
