import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:autocart/pages/invoice.dart';
import 'package:autocart/pages/payment.dart';
import 'package:autocart/pages/pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'login.dart';

class Scanner_B extends StatefulWidget {
  final String user;
  final List<List<dynamic>> items;
  const Scanner_B({Key? key,required this.user,required this.items}) : super(key: key);

  @override
  State<Scanner_B> createState() => _Scanner_BState(user,items);
}

class _Scanner_BState extends State<Scanner_B> {
  final Invoice inv=new Invoice();
  late Razorpay _razorPay;
  final List<List<dynamic>> items;
  final String user;
  int total = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  List<String> scannedBarcodes = [];
  List<String> name = [];
  List<int> price = [];
  final player=AudioPlayer();
  _Scanner_BState(this.user,this.items);
  void initState(){
    super.initState();
    _razorPay=new Razorpay();

  }
  /*void succespayment() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Successful'),
        backgroundColor: Colors.green,
      ),
    );

    // Generate and display the PDF invoice only if payment is successful
    final Uint8List data = await inv.generateInvoice(name, price);
    await inv.savedPdfFile("Invoice.pdf", data);
    OpenFile.open("Invoice.pdf");
  }*/

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment successful");

    String customerName = nameController.text.trim();
    String mobileNumber = mobileController.text.trim();
    String MailId=mailController.text.trim();
    print("customerName=$customerName");
    final filename = "Invoice_$customerName.pdf";
    final Uint8List data = await inv.generateInvoice(name, price, customerName, mobileNumber,MailId);
    final filepath = await inv.savedPdfFile(filename, data);

    if (filepath.isNotEmpty) {
      await inv.sendInvoiceByEmail(MailId, data,filepath);
    } else {
      // Handle the case where the PDF file couldn't be saved
    }
    OpenFile.open('Invoice.pdf');
    update();
    nameController.clear();
    mobileController.clear();
    mailController.clear();
    setState(() {
      scannedBarcodes.clear();
      name.clear();
      price.clear();
      total = 0;
    });
  }
  void clearScannedProducts() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreenAccent,
          title: Text(
            "Clear Scanned Products",
            style: TextStyle(
              fontFamily: 'Muller',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            "Are you sure you want to clear all scanned products?",
            style: TextStyle(
              fontFamily: 'Muller',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Muller',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () {

                setState(() {
                  scannedBarcodes.clear();
                  name.clear();
                  price.clear();
                  total = 0;
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontFamily: 'Muller',
                    fontSize: 14,
                    color: Colors.lightGreenAccent,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void update()async{
    Map<String,dynamic> data = {};
    int total = 0;
    for(var bar in scannedBarcodes)
    {
      String name = check(bar)[0];
      String price = check(bar)[1];
      total+=int.parse(price);
      data.addAll({name:price});
    }
    print(data);
    data.addAll({'Total': total/2});
    FirebaseFirestore.instance.collection(user).add(data);
    print('Updated To FB');
  }

  Future<void> _handlePaymentError() async {
    // Show alert dialog when payment fails
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Failed'),
          content: Text('Your payment was not successful.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleExternalWallet() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected'),
        backgroundColor: Colors.blue,
      ),
    );
  }
  @override
  void dispose(){
    super.dispose();
    _razorPay.clear();
  }

  List<String> check(String barcode){
    List<String> result = ['Undefined Item!!','0'];
    for(var item in items)
      {

        if(identical(item[0], int.parse(barcode)))
          {
            return [item[1], item[2].toString()];
            //break;
          }
      }
    return [];


  }

  Widget item(int index) {
    if (index < 0 || index >= price.length) {
      return SizedBox();
    }
    int p = price[index];
    final itemKey = GlobalKey();
    return AnimatedSwitcher(
      duration:  Duration(milliseconds: 500),
      child: Dismissible(
        key: itemKey,
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            scannedBarcodes = List.from(scannedBarcodes)..removeAt(index);
            name.removeAt(index);
            int deletedPrice = price.removeAt(index);
            total -= deletedPrice;
          });
        },
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(5.0),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 100,

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.lightGreenAccent,
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                child: Center(
                  child: Padding(

                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Text(
                        name[index],
                        style: TextStyle(
                          fontFamily: 'Muller',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12.0,

                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "₹$p.0",
                      style: TextStyle(
                        fontFamily: 'Muller',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          GestureDetector(
              child: Icon(
                  Icons.qr_code_scanner
              ),
            onTap: scanBarcode,

          ),
          SizedBox(width: 6.0,),
          IconButton(
              onPressed: scannedBarcodes.isEmpty
                  ? null
                  : () {
                clearScannedProducts();
              }, icon: Icon(Icons.clear_sharp)),
        ],
        leading: IconButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login(items: items)));}, icon: Icon(Icons.logout_outlined)),
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        elevation: 0,
        title: Text("AutoCart",style: TextStyle(
          fontFamily: 'Battery',
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Stack(
        children: [
          scannedBarcodes.isEmpty || total<=0
              ? Center(
            child: Text(
              "Add Products !",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Muller"
              ),
            ),
          ):
          ListView.builder(

            itemCount: scannedBarcodes.length,
            itemBuilder: (context, index) {
              print(index);
              return item(index);
            },
          ),
          if (total > 0)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SlideAction(
                alignment: Alignment.bottomCenter,
                elevation: 0,
                borderRadius: 12.0,
                innerColor: Colors.black,
                outerColor: Colors.green,
                animationDuration: Duration(milliseconds: 1000),
                text: "Pay ₹$total.0 RS",
                textStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: "Muller",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                sliderButtonIcon: Icon(
                  Icons.fast_forward,
                  color: Colors.lightGreenAccent,
                  size: 25,
                ),
                onSubmit: () async {
                  update();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.lightGreenAccent,
                        title: Text(
                          'Enter Details',
                          style: TextStyle(
                            fontFamily: 'Muller',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: 'Enter Name',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Muller',
                                  fontSize: 12,
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
                                fontFamily: "Muller",
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: mailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter Mail',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Muller',
                                  fontSize: 12,
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
                                fontFamily: "Muller",
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              controller: mobileController,
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
                            SizedBox(height: 10),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.lightGreenAccent,
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () async {
                              String name = nameController.text.trim();
                              String mobile = mobileController.text.trim();
                              if (name.isEmpty || mobile.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please enter your name and mobile number.",
                                      style: TextStyle(
                                        fontFamily: 'Muller',
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                                var options = {
                                  'key': 'rzp_test_Spkh9hBLwHj1UR',
                                  'amount': total * 100,
                                  'name': name,
                                  'description': 'Payment for your purchase',
                                  'prefill': {
                                    'name': name,
                                    'contact': mobile,
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
                                // nameController.clear();
                                // mobileController.clear();
                              }
                            },
                            child: Text(
                              'Pay Now',
                              style: TextStyle(
                                fontFamily: 'Muller',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

              ),
            ),


        ],

      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Call the method to generate the PDF
          final Uint8List data = await inv.generateInvoice(name, price);

          // Save and open the PDF
          await inv.savedPdfFile("Invoice.pdf", data);
        },
        child: Icon(Icons.picture_as_pdf),
      ),*/
    );
  }

  Future<void> scanBarcode() async {
    //player.play(AssetSource('beep-04.mp3'));
    final barcode = await FlutterBarcodeScanner.scanBarcode(
      "#d5e9f3",
      "Close",
      true,
      ScanMode.BARCODE,
    );
    if (barcode != '-1') {

      scannedBarcodes.add(barcode);
      List<String> ans = check(barcode);
      if (ans.isNotEmpty) {
        player.play(AssetSource('beep-04.mp3'));
        scannedBarcodes.add(barcode);
        name.add(ans[0]);
        price.add(int.parse(ans[1]));
        setState(() {total+=int.parse(ans[1]);});
        await scanBarcode();
      } else {
        player.play(AssetSource('beep-10.mp3'));
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
                                fontSize: 18
                              ),
                              ),
                              SizedBox(height: 8,),
                              Text("Not Our Product",style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Muller',
                                fontSize: 12
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

    }
  }
}