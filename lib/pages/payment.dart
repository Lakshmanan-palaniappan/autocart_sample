import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class Payment_Page extends StatefulWidget {
  final int payable;
  const Payment_Page({super.key,required this.payable});

  @override
  State<Payment_Page> createState() => _Payment_PageState();
}

class _Payment_PageState extends State<Payment_Page> {
  late Razorpay _razorPay;

  @override
  void initState(){
    super.initState();
    _razorPay=new Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, succespayment);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, errorpayment);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalwallet);
  }
  @override
  void dispose(){
    super.dispose();
    _razorPay.clear();
  }
  void succespayment(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Successful'),
        backgroundColor: Colors.green,
      ),
    );
  }
  void errorpayment(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed'),
        backgroundColor: Colors.red,
      ),
    );
  }
  void externalwallet(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected'),
        backgroundColor: Colors.blue,
      ),
    );
  }
  void startPayment() {
    TextEditingController contactController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreenAccent,
          title: Text('Enter Contact and Email',
            style: TextStyle(
              fontFamily: 'Muller',
              fontSize: 12,
                fontWeight: FontWeight.bold
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: emailController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Muller',
                    fontSize: 12
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightGreenAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightGreenAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: "Muller"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Mobile Number',
                  hintStyle: TextStyle(
                    fontFamily: 'Muller',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightGreenAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightGreenAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                style: TextStyle(
                  fontFamily: 'Muller',
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 10,),
            ],

          ),

          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(

                foregroundColor: Colors.lightGreenAccent,
                backgroundColor: Colors.black, // Text color
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Padding around the button text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
              ),
              onPressed: () {
                String contact = contactController.text.trim();
                String email = emailController.text.trim();
                if (contact.isEmpty || email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Stack(
                        children: [
                          Container(
                              padding: EdgeInsets.all(16),
                              height: 90,
                              decoration: BoxDecoration(
                                  color: Color(0xFFC72C41),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: const Row(

                                children: [
                                  SizedBox(width: 48,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Oh Snap !",style: TextStyle(
                                            fontFamily: 'Muller',
                                            color: Colors.white,
                                            fontSize: 12
                                        ),
                                        ),
                                        SizedBox(height: 8,),
                                        Text("Please Enter Name And Mobile Number",style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Muller',
                                            fontSize: 8
                                        ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                }
                else{
                  Navigator.pop(context);
                  var options = {
                    'key': 'rzp_test_Spkh9hBLwHj1UR',
                    'amount': widget.payable * 100,
                    'name': 'AutoCart',
                    'description': 'Payment for your purchase',
                    'prefill': {
                      'name': emailController.text.trim(),
                      'contact': contactController.text.trim(),
                    },
                    'external': {
                      'wallets': ['paytm']
                    }
                  };
                  try {
                    _razorPay.open(options);
                  } catch (e) {
                    debugPrint('Error: $e');
                  }
                  contactController.clear();
                  emailController.clear();

                }

              },
              child: Text(
                  'Pay Now',
                style: TextStyle(
                  fontFamily: 'Muller'
                ),
              ),
            ),
          ],
        );
      },
    );
  }



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
      body: Column(
        children: [
          Container(
            child:Text('Amount to Pay: ₹${widget.payable}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: startPayment,
            child: Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}
