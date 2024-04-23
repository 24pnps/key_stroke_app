import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // initializes several components used for creating a login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // trim is for delete the white space before and after
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Check if email and password are not empty
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Error'),
          content: Text('Please enter your email and password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      // Calculate average password keystrokes
      double averagePasswordKeystrokes =
          _calculateAveragePasswordKeystrokes(password);

      // Sign in with email and password
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user data from Firestore
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Extract average keystrokes from user data
      final double averageKeystrokes = userDataSnapshot['averageKeystrokes'];

      // Compare averageKeystrokes with the calculated averagePasswordKeystrokes
      if (averageKeystrokes != averagePasswordKeystrokes) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text('Keystrokes did not match.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Navigate to the home page upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(email: email, username: ''),
        ),
      );
    } catch (e) {
      // Show error message if login fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Error'),
          content: Text('Failed to login. Please check your credentials.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

// Function to calculate average password keystrokes
  double _calculateAveragePasswordKeystrokes(String password) {
    int totalKeystrokes = 0;
    for (int i = 0; i < password.length - 1; i++) {
      int keystroke = password.codeUnitAt(i + 1) - password.codeUnitAt(i);
      totalKeystrokes += keystroke;
    }
    return totalKeystrokes / (password.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFDFFE9),
        title: Center(),
      ),
      backgroundColor: Color(0xFFFDFFE9),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'WELCOME',
                style: GoogleFonts.poppins(
                    fontSize: 40.0,
                    color: Color(0xFF74BCFF),
                    letterSpacing: 10.0),
              ),
              Text(
                'BACK!',
                style: GoogleFonts.poppins(
                    fontSize: 40.0,
                    color: Color(0xFF74BCFF),
                    letterSpacing: 10.0),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF74BCFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(300.0),
                    topRight: Radius.circular(300.0),
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 150.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style:
                          GoogleFonts.poppins().copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            GoogleFonts.poppins().copyWith(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_‘{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: GoogleFonts.poppins()
                          .copyWith(color: Color(0xFFFDFFE9)),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.poppins()
                            .copyWith(color: Color(0xFFFDFFE9)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFDFFE9)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            color:
                                const Color(0xFFFDFFE9), // #FDFFE9 text color
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _login, // Call login function

                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                Color(0xFFFDFFE9), // Background color
                            foregroundColor:
                                Color(0xFF74BCFF), // Text (icon) color
                          ),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Column(
                        children: [
                          Text("Don't have an account? ",
                              style: GoogleFonts.poppins(
                                  color: Color(0xFFFDFFE9))),
                          SizedBox(height: 5), // Adjust the height as needed
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              "Register here",
                              style: GoogleFonts.poppins()
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
