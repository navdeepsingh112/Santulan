import 'package:flutter/material.dart';
import 'package:green_quest/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_quest/video.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your App Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(width: 10.0),
              Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  '500',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.0,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HomeContent(),
          NotificationsContent(),
          ProfileContent(), // New content widget
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.green,
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          currentIndex: currentPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Badge(
                child: Icon(
                  Icons.home,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                child: Icon(
                  Icons.calendar_today,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              label: 'Redeem',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Fetch challenges from Firestore
      future: fetchChallenges(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> challenges = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Challenges',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 2000.0,
                  height: 2.0,
                  color: Colors.black,
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                challenges[index],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CameraFloatingButton()),
                                );
                                // Add join button logic here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text('Join'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Function to fetch challenges from Firestore
  Future<List<String>> fetchChallenges() async {
    try {
      // Replace 'Challenges' with your Firestore collection name
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Challanges').get();
      print(querySnapshot.docs.map((e) => print(e)));
      List<String> challenges =
          querySnapshot.docs.map((doc) => doc['Name'] as String).toList();
      print(challenges);
      return challenges;
    } catch (e) {
      print('Error fetching challenges: $e');
      return [];
    }
  }
}

class NotificationsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add your notifications content here
    return Center(
      child: Text('Community'),
    );
  }
}

class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add your profile content here
    return Center(
      child: Text('Redeem'),
    );
  }
}
