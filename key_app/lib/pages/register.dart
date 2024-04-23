import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define variables to store keystroke dynamics data
  Map<String, List<int>> keystrokeData = {};

  @override
  void initState() {
    super.initState();
    _addKeyEventListeners(_usernameController, 'username');
    _addKeyEventListeners(_emailController, 'email');
    _addKeyEventListeners(_passwordController, 'password');
  }

  // Add key event listeners to capture keystroke dynamics
  void _addKeyEventListeners(
      TextEditingController controller, String fieldName) {
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final lastChar = controller.text.runes.last;
        keystrokeData.putIfAbsent(fieldName, () => []);
        keystrokeData[fieldName]!.add(now);
      }
    });
  }

  // Calculate dwell time (down-up digraph)
  int _calculateDwellTime(String fieldName) {
    final List<int> events = keystrokeData[fieldName]!;
    if (events.length >= 2) {
      return events.last - events.first;
    }
    return 0;
  }

  // Calculate digraphs
  int _calculateDigraph(String fieldName, String digraphType) {
    final List<int> events = keystrokeData[fieldName]!;
    if (events.length >= 2) {
      switch (digraphType) {
        case 'up-down':
          return events[1] - events[0];
        case 'up-up':
          return events[1] - events[0];
        case 'down-down':
          return events.last - events[events.length - 2];
        case 'down-up':
          return events.first - events[events.length - 2];
      }
    }
    return 0;
  }

  double _calculateAverageConfirmPasswordKeystrokes(int index) {
    final List<int> upDownDigraphs = [];
    final List<int> upUpDigraphs = [];
    final List<int> downDownDigraphs = [];
    final List<int> downUpDigraphs = [];
    int confirmPasswordCount = 0;

    final List<int>? confirmDwellTimes = keystrokeData['confirmPassword$index'];
    if (confirmDwellTimes != null && confirmDwellTimes.isNotEmpty) {
      // Add debug print here
      print('Confirm Password $index dwell times: $confirmDwellTimes');

      for (int j = 0; j < confirmDwellTimes.length - 1; j++) {
        final int digraph = confirmDwellTimes[j + 1] - confirmDwellTimes[j];
        // Add debug print here
        print('Digraph: $digraph');
        print('Up-Down Digraphs: $upDownDigraphs');
        print('Up-Up Digraphs: $upUpDigraphs');
        print('Down-Down Digraphs: $downDownDigraphs');
        print('Down-Up Digraphs: $downUpDigraphs');

        if (digraph > 0) {
          upDownDigraphs.add(digraph);
        } else if (digraph < 0) {
          downUpDigraphs.add(-digraph);
        } else {
          upUpDigraphs.add(0);
        }
      }
      confirmPasswordCount += confirmDwellTimes.length - 1;
    }

    final int totalCount = upDownDigraphs.length +
        upUpDigraphs.length +
        downDownDigraphs.length +
        downUpDigraphs.length;
    final int totalSum =
        upDownDigraphs.fold<int>(0, (prev, element) => prev + element) +
            upUpDigraphs.fold<int>(0, (prev, element) => prev + element) +
            downDownDigraphs.fold<int>(0, (prev, element) => prev + element) +
            downUpDigraphs.fold<int>(0, (prev, element) => prev + element);

    return totalCount > 0 ? totalSum / totalCount : 0;
  }

  double _calculateAveragePasswordKeystrokes() {
    final List<int> dwellTimes = keystrokeData['password']!;
    final List<int> upDownDigraphs = [];
    final List<int> upUpDigraphs = [];
    final List<int> downDownDigraphs = [];
    final List<int> downUpDigraphs = [];

    // Calculate dwell times and digraphs for the password field
    for (int i = 0; i < dwellTimes.length - 1; i++) {
      final int digraph = dwellTimes[i + 1] - dwellTimes[i];
      if (digraph > 0) {
        upDownDigraphs.add(digraph);
      } else if (digraph < 0) {
        downUpDigraphs.add(-digraph);
      } else {
        upUpDigraphs.add(0);
      }
    }

    for (int i = 0; i < dwellTimes.length - 1; i++) {
      final int digraph = dwellTimes[i + 1] - dwellTimes[i];
      if (i > 0) {
        final int prevDigraph = dwellTimes[i] - dwellTimes[i - 1];
        if (prevDigraph > 0 && digraph > 0) {
          downDownDigraphs.add(digraph - prevDigraph);
        }
      }
    }

    final int totalCount = upDownDigraphs.length +
        upUpDigraphs.length +
        downDownDigraphs.length +
        downUpDigraphs.length;
    final int totalSum =
        upDownDigraphs.fold<int>(0, (prev, element) => prev + element) +
            upUpDigraphs.fold<int>(0, (prev, element) => prev + element) +
            downDownDigraphs.fold<int>(0, (prev, element) => prev + element) +
            downUpDigraphs.fold<int>(0, (prev, element) => prev + element);

    // Calculate the average keystrokes for confirm password fields
    double totalConfirmPasswordKeystrokes = 0;
    for (int i = 1; i <= 5; i++) {
      // Assuming 5 confirm password fields
      totalConfirmPasswordKeystrokes +=
          _calculateAverageConfirmPasswordKeystrokes(i);
    }
    double averageConfirmPasswordKeystrokes = totalConfirmPasswordKeystrokes /
        5; // Assuming 5 confirm password fields

    // Calculate the overall average keystrokes
    return totalCount > 0
        ? (totalSum + averageConfirmPasswordKeystrokes) / totalCount
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF74BCFF),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFFE9),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'CREATE AN\nACCOUNT',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF74BCFF),
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
                                color: const Color(0xFFFDFFE9),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFDFFE9),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFDFFE9),
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
                                color: const Color(0xFFFDFFE9),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFDFFE9),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFDFFE9),
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
                            onChanged: (_) {},
                            onFieldSubmitted: (_) {},
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color(0xFFFDFFE9),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFDFFE9),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFDFFE9),
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
                              onChanged: (_) {},
                              onFieldSubmitted: (_) {},
                              decoration: InputDecoration(
                                labelText: 'Confirm Password $i',
                                labelStyle: GoogleFonts.poppins(
                                  color: const Color(0xFFFDFFE9),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFFFDFFE9),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFFFDFFE9),
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
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFFDFFE9),
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );

                                    // Calculate keystroke metrics
                                    double averagePasswordKeystrokes =
                                        _calculateAveragePasswordKeystrokes();
                                    Map<String, double>
                                        confirmPasswordAverages = {};
                                    for (int i = 1; i <= 5; i++) {
                                      double averageConfirmPasswordKeystrokes =
                                          _calculateAverageConfirmPasswordKeystrokes(
                                              i);
                                      confirmPasswordAverages[
                                              'confirmPassword$i'] =
                                          averageConfirmPasswordKeystrokes;
                                    }

                                    Map<String, dynamic> userData = {
                                      'email': _emailController.text,
                                      'username': _usernameController.text,
                                      'password': _passwordController.text,
                                      'averageKeystrokes':
                                          averagePasswordKeystrokes,
                                      'averageConfirmPasswordKeystrokes':
                                          confirmPasswordAverages,
                                    };

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userCredential.user!.uid)
                                        .set(userData);

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

                                    Navigator.pushNamed(context, '/');
                                  } catch (e) {
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
                                backgroundColor: const Color(0xFFFDFFE9),
                                foregroundColor: const Color(0xFF74BCFF),
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
                              SizedBox(height: 5),
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
