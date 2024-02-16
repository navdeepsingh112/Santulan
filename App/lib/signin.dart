import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_quest/home1.dart';
import 'package:green_quest/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isPasswordValid = true;

  void _login() async {
    // Reset password validation status
    setState(() {
      isPasswordValid = true;
    });

    // Perform login logic here
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // Sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user's email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Successful login logic here
        print("Login successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Email not verified, show error message
        print("Email not verified. Please verify your email.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Invalid credentials, show error message
        print("Invalid email or password. Please check or sign up.");
      } else {
        // Other login errors
        print("Error logging in: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(159, 190, 140, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Green Quest',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            // Circle avatar
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: isPasswordValid
                    ? null
                    : 'Password must be 8 characters long',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(109, 187, 62, 1),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                );
              },
              child: Text('Signup'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(109, 187, 62, 1),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
