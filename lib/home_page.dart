import 'package:auth/userPage.dart';
import 'package:auth/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String email = "testhostelstudent@gmail.com";

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
        MaterialPageRoute(builder: (context) => const UserPage(userType: "Admin Page")),
      );
    } else if (userType == "Hostel student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPage(userType: "Hostel Student Page")),
      );
    } else if (userType == "Hostel Mentor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPage(userType: "Hostel Mentor Page")),
      );
    } else if (userType == "Dayscholar student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPage(userType: "Day-scholar Student Page")),
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

    request.fields.addAll({'email': email});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: email,
              items: <String>[
                'testhostelstudent@gmail.com',
                'test_mentor@gmail.com',
                'test_hostel_admin@gmail.com',
                'test_dayscholar@gmail.com'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  email = value??"testhostelstudent@gmail.com";
                });
              },
            ),
            ElevatedButton.icon(
              onPressed: singInFun,
              icon: const Icon(Icons.abc),
              label: const Text("Google Auth"),
            ),
          ],
        ),
      ),
    );
  }
}
