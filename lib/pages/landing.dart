import 'package:autocart/pages/login.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'barcode_scanner.dart';

class Landing_page extends StatefulWidget {
  const Landing_page({super.key});
  
  @override
  State<Landing_page> createState() => _Landing_pageState();
}

class _Landing_pageState extends State<Landing_page> {
  List<List<dynamic>> data = [[]];
  _Landing_pageState(){
    loadCSV();
  }
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }
  void loadCSV ( ) async {
    final  rawData = await rootBundle.loadString("assets/items.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(rawData);
    setState(() {
      data = _listData;
    });
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
        MaterialPageRoute(builder: (context) => Scanner_B(user: loggedInUser,items: data,)),
      );
    } else {
      // User is not logged in, navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login(items: data,)),
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
