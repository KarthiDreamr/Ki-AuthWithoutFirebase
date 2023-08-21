import 'package:flutter/material.dart';

class KiMentorPage extends StatelessWidget {
  const KiMentorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentor Page"),
      ),
      body: Container(
        color: Colors.orange,
      ),
    );
  }
}