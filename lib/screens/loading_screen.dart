import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading')),
      body: Center(child: CircularProgressIndicator(color: Colors.grey)),
    );
  }
}
