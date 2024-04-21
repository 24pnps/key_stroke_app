import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                    TextField(
                      controller: _emailController,
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
                    ),
                    SizedBox(height: 16.0),
                    TextField(
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
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      style: GoogleFonts.poppins()
                          .copyWith(color: Color(0xFFFDFFE9)),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: GoogleFonts.poppins()
                            .copyWith(color: Color(0xFFFDFFE9)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFDFFE9)),
                        ),
                      ),
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
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
