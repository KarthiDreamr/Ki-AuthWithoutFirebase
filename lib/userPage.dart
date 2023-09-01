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
  // void singOut() async {
  //   await GoogleSignIn().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userType),
        actions: [IconButton(onPressed: () {
          storeState("firstLogin");
          // singOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()),);
        }, icon: const Icon(Icons.logout))],
      ),
      body: Container(
        color: Colors.blue,
        // child: Text(userEmail),
      ),
    );
  }
}


// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
// // ignore: library_private_types_in_public_api
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("GeeksForGeeks"),
//         backgroundColor: Colors.green,
//       ),
//       // ignore: avoid_unnecessary_containers
//       body: Container(
//         child: Center(
//           child: ElevatedButton(
//             onPressed: () {
//
//             },
//             child: const Text("Show alert Dialog box"),
//           ),
//         ),
//       ),
//     );
//   }
// }
