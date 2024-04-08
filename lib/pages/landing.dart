import 'package:autocart/pages/barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
    await Future.delayed(
        Duration(
          milliseconds: 10000
    ),
        (){
          
        }
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Scanner_B()));
    
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
