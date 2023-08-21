import 'package:flutter/material.dart';

class KiAdminPage extends StatelessWidget {
  const KiAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}