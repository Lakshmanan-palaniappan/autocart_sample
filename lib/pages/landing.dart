import 'package:autocart/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'barcode_scanner.dart';

class Landing_page extends StatefulWidget {
  const Landing_page({super.key});
  
  @override
  State<Landing_page> createState() => _Landing_pageState();
}

class _Landing_pageState extends State<Landing_page> {
  void initState(){
    super.initState();
    _navigatetohome();
  }
  _navigatetohome()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInUser = prefs.getString('loggedInUser') ?? '';
    await Future.delayed(
        Duration(
          milliseconds: 10000
    ),
        (){
          
        }
    );
    if (loggedInUser.isNotEmpty) {
      // User is logged in, navigate to barcode scanner page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Scanner_B(user: loggedInUser)),
      );
    } else {
      // User is not logged in, navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.network
          ("https://lottie.host/20a3b10f-bcca-467e-adb6-66f6b459d266/nhS7JwmoMe.json"),
      ),

    );
  }
}
