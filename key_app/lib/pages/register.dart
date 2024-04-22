import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Create typing speed calculators for password and confirm password
  TypingSpeedCalculator passwordTypingSpeedCalculator = TypingSpeedCalculator();
  TypingSpeedCalculator confirmPasswordTypingSpeedCalculator =
      TypingSpeedCalculator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF74BCFF), // #74BCFF background color
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFFE9), // #FDFFE9 half-circle color
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'CREATE AN\nACCOUNT',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF74BCFF), // #FDFFE9 text color
                        fontSize: 30,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color(
                                    0xFFFDFFE9), // #FDFFE9 text color
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                      0xFFFDFFE9), // #FDFFE9 line color
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                      0xFFFDFFE9), // #FDFFE9 line color
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }

                              if (value.length < 5) {
                                return 'Username must be at least 5 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color(
                                    0xFFFDFFE9), // #FDFFE9 text color
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                      0xFFFDFFE9), // #FDFFE9 line color
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                      0xFFFDFFE9), // #FDFFE9 line color
                                ),
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
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            onChanged: (_) {
                              // Start tracking typing time for password field
                              passwordTypingSpeedCalculator.startTyping();
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color(
                                    0xFFFDFFE9), // #FDFFE9 text color
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                      0xFFFDFFE9), // #FDFFE9 line color
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                      0xFFFDFFE9), // #FDFFE9 line color
                                ),
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
                        ),
                        SizedBox(height: 10),
                        for (int i = 1; i <= 5; i++)
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              obscureText: true,
                              onChanged: (_) {
                                // Start tracking typing time for confirm password field
                                confirmPasswordTypingSpeedCalculator
                                    .startTyping();
                              },
                              decoration: InputDecoration(
                                labelText: 'Confirm Password $i',
                                labelStyle: GoogleFonts.poppins(
                                  color: const Color(
                                      0xFFFDFFE9), // #FDFFE9 text color
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(
                                        0xFFFDFFE9), // #FDFFE9 line color
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(
                                        0xFFFDFFE9), // #FDFFE9 line color
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                color: const Color(
                                    0xFFFDFFE9), // #FDFFE9 text color
                                fontSize: 16,
                                letterSpacing: 2, // Reduced font size
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    // Register the user with Firebase Authentication
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );

                                    // Store user information in Firestore
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userCredential.user!.uid)
                                        .set({
                                      'email': _emailController.text,
                                      'username': _usernameController.text,
                                      'password': _passwordController.text,
                                    });

                                    // Show registration success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Register Successful',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );

                                    // Navigate to login screen
                                    Navigator.pushNamed(context, '/');
                                  } catch (e) {
                                    // Show error message if registration fails
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$e'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor:
                                    const Color(0xFFFDFFE9), // Background color
                                foregroundColor: const Color(
                                    0xFF74BCFF), // Text (icon) color
                              ),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Text("Already have an account? ",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFFFDFFE9))),
                              SizedBox(
                                  height: 5), // Adjust the height as needed
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Login here",
                                  style: GoogleFonts.poppins().copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Typing speed calculator class
class TypingSpeedCalculator {
  List<DateTime> keystrokes = [];
  DateTime? startTime;

  void startTyping() {
    startTime = DateTime.now();
  }

  void recordKeystroke() {
    keystrokes.add(DateTime.now());
  }

  void stopTyping() {
    // Optionally, you can stop tracking keystrokes or handle any cleanup here.
  }

  double calculateTypingSpeed() {
    if (keystrokes.isEmpty || startTime == null) {
      return 0.0;
    }
    Duration totalDuration = keystrokes.last.difference(startTime!);
    int numberOfKeystrokes = keystrokes.length;
    double charactersPerMillisecond =
        numberOfKeystrokes / totalDuration.inMilliseconds;
    double charactersPerMinute =
        charactersPerMillisecond * 60000; // Convert to characters per minute
    return charactersPerMinute;
  }

  Future<void> storeTypingSpeedInFirestore(String users) async {
    double typingSpeed = calculateTypingSpeed();
    try {
      await FirebaseFirestore.instance.collection(users).add({
        'typing_speed': typingSpeed,
        'timestamp': DateTime.now(),
      });
      print('Typing speed data stored in Firestore for $users.');
    } catch (error) {
      print('Error storing typing speed data for $users: $error');
    }
  }
}
