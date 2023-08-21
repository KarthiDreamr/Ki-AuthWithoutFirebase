import 'package:flutter/material.dart';

class KiErrorPage extends StatelessWidget {
  const KiErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error Occoured"),
      ),
      body: const Center(child: Text("It's not you , It's our fault")),
    );
  }
}