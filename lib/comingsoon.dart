import 'package:flutter/material.dart';

class Comingsoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text(
            'Your App Name',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Coming Soon...',
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }
}
