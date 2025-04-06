import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mcq_screen.dart';
import 'welcome_screen.dart';
import 'photoupload_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart'; // Import the chatbot screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => WelcomePage()),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String username = user != null
        ? (user.displayName?.isNotEmpty ?? false
            ? user.displayName!
            : user.email?.split('@')[0] ?? '')
        : '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF436286),
        title: const Text(
          'Stress Detection App',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<int>(
              icon: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: TextStyle(
                      color: Color(0xFF436286),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              onSelected: (item) {
                if (item == 0) {
                  _navigateToProfile(context);
                } else if (item == 1) {
                  _logout(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF436286)),
                      SizedBox(width: 8),
                      Text('Profile',
                          style: TextStyle(color: Color(0xFF436286))),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Color(0xFF436286)),
                      SizedBox(width: 8),
                      Text('Logout',
                          style: TextStyle(color: Color(0xFF436286))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFFAF9F6),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, $username!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF436286)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Choose an option below to get started:',
                  style: TextStyle(fontSize: 16, color: Color(0xFF436286)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildButton(
                  context: context,
                  icon: Icons.quiz,
                  text: 'Start Stress Test',
                  screen: MCQScreen(),
                ),
                SizedBox(height: 20),
                _buildButton(
                  context: context,
                  icon: Icons.camera_alt,
                  text: 'Camera Stress Detection',
                  screen: PhotoUploadScreen(),
                ),
                SizedBox(height: 40),
                Text(
                  'Your mental health matters. Stay calm and stress-free!',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF436286)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ChatScreen()));
        },
        backgroundColor: Color(0xFF436286),
        child: Icon(Icons.chat, color: Colors.white), // Chatbot icon
        tooltip: 'Chat with Stress Bot',
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Widget screen,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF436286),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
