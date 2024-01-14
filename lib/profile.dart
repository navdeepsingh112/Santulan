import 'package:flutter/material.dart';
import 'package:green_quest/comingsoon.dart';

class Profile extends StatelessWidget {
  final List<String> buttonNames = [
    'My stats',
    'Profile Details',
    'My coupons',
    'FAQ',
    'Settings',
    'Verify yourself as an event organiser',
    'About Us',
  ];

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
            Expanded(
              child: ListView.builder(
                itemCount: buttonNames.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: CustomButton(
                      text: buttonNames[index],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Comingsoon()),
                        );
                        // Add onPressed logic for each button
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({Key? key, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          SizedBox(width: 20.0),
          Text(text),
        ],
      ),
    );
  }
}
