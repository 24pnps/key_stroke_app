import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class Home extends StatefulWidget {
  final String email;
  final String username;

  Home({required this.email, required this.username});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _email = widget.email;
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('User')
          .where('email', isEqualTo: widget.email)
          .get();

      if (userData.docs.isNotEmpty) {
        setState(() {
          _username = userData.docs.first['username'];
          _email = userData.docs.first['email'];
        });
      } else {
        print('No user data found for email: ${widget.email}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins()),
        backgroundColor: Color(0xFFFDFFE9),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFDFFE9),
      body: Stack(
        children: [
          // Blue Container Layer
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 550,
              decoration: BoxDecoration(
                color: Color(0xFF74BCFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(300),
                  topRight: Radius.circular(300),
                ),
              ),
            ),
          ),

          Positioned(
            top: 90, // Adjust the top position as needed
            left: 120, // Adjust the left position to center the mouth
            child: Container(
              width: 200, // Adjust the width of the mouth as needed
              height: 20, // Adjust the height of the mouth as needed
              decoration: BoxDecoration(
                color: Color(0xFFF6CE47),
                borderRadius:
                    BorderRadius.circular(20), // Make it a rounded rectangle
              ),
            ),
          ),

          Positioned(
            top: 75, // Adjust the top position as needed
            right: 145, // Adjust the right position as needed
            child: Container(
              width: 50, // Adjust the width of the eye as needed
              height: 50, // Adjust the height of the eye as needed
              decoration: BoxDecoration(
                color: Color(0xFFF6CE47),
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
          ),

          // Eye right
          Positioned(
            top: 80, // Adjust the top position as needed
            right: 150, // Adjust the right position as needed
            child: Container(
              width: 40, // Adjust the width of the eye as needed
              height: 40, // Adjust the height of the eye as needed
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
          ),
          Positioned(
            top: 90, // Adjust the top position as needed
            left: 250, // Adjust the left position as needed
            child: Container(
              width: 10, // Adjust the width of the eye as needed
              height: 10, // Adjust the height of the eye as needed
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
          ),

          Positioned(
            top: 75, // Adjust the top position as needed
            left: 145, // Adjust the left position as needed
            child: Container(
              width: 50, // Adjust the width of the eye as needed
              height: 50, // Adjust the height of the eye as needed
              decoration: BoxDecoration(
                color: Color(0xFFF6CE47),
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
          ),

          // Eye left
          Positioned(
            top: 80, // Adjust the top position as needed
            left: 150, // Adjust the left position as needed
            child: Container(
              width: 40, // Adjust the width of the eye as needed
              height: 40, // Adjust the height of the eye as needed
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
          ),

          Positioned(
            top: 90, // Adjust the top position as needed
            left: 160, // Adjust the left position as needed
            child: Container(
              width: 10, // Adjust the width of the eye as needed
              height: 10, // Adjust the height of the eye as needed
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
          ),

          // Mouth
          Positioned(
            top: 150,
            left: 205,
            child: Container(
              width: 20, // Adjust the width of the eye as needed
              height: 20, // Adjust the height of the eye as needed
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
          ),

          // White Container Layer
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Container(
              height: 550,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(300),
                  topRight: Radius.circular(300),
                ),
              ),
            ),
          ),

          // User icon
          Positioned(
            top: 200,
            left: 170,
            child: Container(
              width:
                  100, // Adjust the width and height of the container as needed
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFF3B3735),
                shape: BoxShape.circle, // Make it a circle
              ),
              child: Center(
                child: Icon(
                  Icons.person, // Use the user icon
                  color: Colors.white, // Set the icon color
                  size: 60, // Adjust the size of the icon as needed
                ),
              ),
            ),
          ),
          
          // User name
          Positioned(
            top: 320,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '$_username',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 40,
                ),
              ),
            ),
          ),

          // User email
          Positioned(
            top: 400, // Adjust the top position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '$_email',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Logout Button
          Positioned(
            top: 600,
            right: 20,
            child: Row(
              children: [
                Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Color(0xFFF6CE47), // Background color
                    foregroundColor: Colors.black, // Text (icon) color
                  ),
                  child: Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
