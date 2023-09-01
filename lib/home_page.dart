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
    }
    else if (userType == "Dayscholar student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPage(userType: "Day-scholar Student Page")),
      );
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiErrorPage()),
      );
    }

  }

  // List<String> pageName = [];

  void GsignIn() async {
    try{
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if(googleSignInAccount==null){
        // await GoogleSignIn().signOut();
        errorDialogPopup();
        return;
      }
      print('--------------------');
      print(googleSignInAccount.email);
      print('--------------------');

      var request = http.MultipartRequest(
          'POST', Uri.parse('https://dev-checkin.kct.ac.in/api/login/'));

      request.fields.addAll({'email': googleSignInAccount.email});


      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        print("Response from Endpoint $responseString");
        var responseJson = json.decode(responseString);
        var userType = responseJson["authenticated successfully"];
        print("User Type is $userType");

        if(userType!=null){
          userType ??= "Error";
          pageSwitch(userType, true);

          print("hello Google");
        }
        else{
          errorDialogPopup();
        }



      } else {
        print("Custom Error Response: ${response.reasonPhrase} ");
      }

    }
    catch(e) {
      print("Error Occoured $e");
    }

  }

  Future staticLogin() async {
    try {

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
        print("hello");
      } else {
        print("Custom Error Response: ${response.reasonPhrase} ");
      }
    }
    catch(e){
      print("Error Occoured $e");
    }
  }
  void errorDialogPopup(){
     showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("UnRegistered User"),
        content: const Text("The email is not registered"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Close")
          ),
        ],
      ),
    );
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
              onPressed: staticLogin,
              icon: const Icon(Icons.abc),
              label: const Text("Log in"),
            ),
           const SizedBox(
             height: 20,
           ),
            ElevatedButton.icon(
              onPressed: GsignIn,
              icon: Image.asset('assets/google-logo.png',scale: 8,),
              label: const Text("Google Sign In"),
            )
          ],
        ),
      ),
    );
  }
}
