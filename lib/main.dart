import 'package:auth/dayscholar.dart';
import 'package:auth/error_page.dart';
import 'package:auth/home_page.dart';
import 'package:flutter/material.dart';
import 'package:auth/admin_page.dart';
import 'package:auth/mentor_page.dart';
import 'package:auth/student_page.dart';
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
      return const KiAdminPage();
    } else if (userType == "Hostel student") {
      return const KiStudentPage();
    } else if (userType == "Hostel Mentor") {
      return const KiMentorPage();
    } else if (userType == "Dayscholar student") {
      return const KiDayScholar();
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
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
