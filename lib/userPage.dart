import 'package:auth/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key,required this.userType});
  
  final String userType;
  final storage = const FlutterSecureStorage();

  void storeState(String userType) async {
    await storage.write(key: "userType", value: userType);
  }
  void singOut() async {
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userType),
        actions: [IconButton(onPressed: () {
          storeState("firstLogin");
          singOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()),);
        }, icon: const Icon(Icons.logout))],
      ),
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}
