import 'package:flutter/material.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text(title)],
        ),
      ),
      body: Center(
          child: Padding(padding: const EdgeInsets.all(10), child: child)),
    );
  }
}
