import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class Payment_Page extends StatefulWidget {
  const Payment_Page({super.key});

  @override
  State<Payment_Page> createState() => _Payment_PageState();
}

class _Payment_PageState extends State<Payment_Page> {
  late Razorpay _razorPay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: Text(
          "AutoCart",
          style: TextStyle(
            fontFamily: 'Battery'
          ),
        ),
        centerTitle: true,

      ),
      backgroundColor: Colors.black,
    );
  }
}
