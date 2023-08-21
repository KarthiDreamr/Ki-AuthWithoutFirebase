import 'package:auth/admin_page.dart';
import 'package:auth/dayscholar.dart';
import 'package:auth/error_page.dart';
import 'package:auth/mentor_page.dart';
import 'package:auth/student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final storage = const FlutterSecureStorage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void storeState(String userType) async {
    await widget.storage.write(key: "userType", value: userType);
  }

  void pageSwitch(String userType, bool write) {
    if (write) {
      storeState(userType);
    }

    if (userType == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiAdminPage()),
      );
    } else if (userType == "Hostel student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiStudentPage()),
      );
    } else if (userType == "Hostel Mentor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiMentorPage()),
      );
    } else if (userType == "Dayscholar student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiDayScholar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiErrorPage()),
      );
    }
  }

  Future singInFun() async {
    var gresponse = await GoogleSignIn().signIn();
    print(gresponse);

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://dev-checkin.kct.ac.in/api/login/'));

    request.fields.addAll({'email': 'test_dayscholar@gmail.com'});

    /*
    testhostelstudent@gmail.com
    test_mentor@gmail.com
    test_hostel_admin@gmail.com
    test_dayscholar@gmail.com
    */

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      print("Response from Endpoint $responseString");
      var responseJson = json.decode(responseString);
      var userType = responseJson["authenticated successfully"];
      print("User Type is $userType");

      pageSwitch(userType, true);
    } else {
      print("Custom Error Response: ${response.reasonPhrase} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Auth"),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: singInFun,
          icon: const Icon(Icons.abc),
          label: const Text("Google Auth"),
        ),
      ),
    );
  }
}
