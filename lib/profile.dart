import 'dart:html';
import 'dart:js_util';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Profile(),
    );
  }
}

class Profile extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor:
                      Colors.black, // Replace with your avatar image asset
                ),
                SizedBox(width: 16.0),
                Text(
                  'Hi, user_name',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(text: 'My stats'),
                SizedBox(height: 15.0),
                CustomButton(text: 'Profile Details'),
                SizedBox(height: 15.0),
                CustomButton(text: 'My coupons'),
                SizedBox(height: 15.0),
                CustomButton(text: 'FAQ'),
                SizedBox(height: 15.0),
                CustomButton(text: 'Settings'),
                SizedBox(height: 15.0),
                CustomButton(text: 'Verify yourself as an event organiser'),
                SizedBox(height: 15.0),
                CustomButton(text: 'About Us'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add onPressed logic for each button
      },
      child: Row(
        children: [
          SizedBox(width: 20.0),
          Text(text),
        ],
      ),
    );
  }
}

