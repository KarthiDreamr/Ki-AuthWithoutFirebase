import 'package:auth/home_page.dart';
import 'package:flutter/material.dart';

class KiErrorPage extends StatelessWidget {
  const KiErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error Occoured"),
          actions: [IconButton(onPressed: () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }, icon: const Icon(Icons.logout))],
      ),
      body: const Center(child: Text("It's not you , It's our fault")),
    );
  }
}