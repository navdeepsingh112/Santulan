import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CommunityPage(),
    );
  }
}

class CommunityPage extends StatelessWidget {
  final List<String> userNames = ['user_name1', 'user_name2', 'user_name3', 'user_name4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('App Name and logo'),
            Spacer(), // To create space between elements
            Text('500'), // Number of points
            IconButton(
              icon: Icon(Icons.menu), // Replace with your custom image icon
              onPressed: () {
                // Menu button action
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: userNames.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                // Display user profile image
              ),
              title: Text(userNames[index]),
              // Add more user details or post content here
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
        ],
        // Set the current index for the active tab
      ),
    );
  }
}
