import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: GoogleFonts.poppins(
                              color:
                                  const Color(0xFFFDFFE9), // #FDFFE9 text color
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
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: GoogleFonts.poppins(
                              color:
                                  const Color(0xFFFDFFE9), // #FDFFE9 text color
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
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: GoogleFonts.poppins(
                              color:
                                  const Color(0xFFFDFFE9), // #FDFFE9 text color
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
                        ),
                      ),
                      SizedBox(height: 10),
                      for (int i = 1; i <= 5; i++)
                        SizedBox(
                          height: 60,
                          child: TextField(
                            obscureText: true,
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
                          ),
                        ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              color:
                                  const Color(0xFFFDFFE9), // #FDFFE9 text color
                              fontSize: 16,
                              letterSpacing: 2, // Reduced font size
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color(0xFFFDFFE9), // Background color
                              foregroundColor:
                                  const Color(0xFF74BCFF), // Text (icon) color
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
                            SizedBox(height: 5), // Adjust the height as needed
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
