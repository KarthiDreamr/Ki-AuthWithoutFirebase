import 'package:flutter/material.dart';

class KiStudentPage extends StatelessWidget {
  const KiStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Page"),
      ),
      body: Container(
        color: Colors.lightGreenAccent,
      ),
    );
  }
}