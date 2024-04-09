import 'dart:ffi';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Scanner_B extends StatefulWidget {
  final String user;
  const Scanner_B({Key? key,required this.user}) : super(key: key);

  @override
  State<Scanner_B> createState() => _Scanner_BState(user);
}

class _Scanner_BState extends State<Scanner_B> {
  final String user;
  List<String> scannedBarcodes = [];
  final player=AudioPlayer();
  _Scanner_BState(this.user);

  Widget item(int index) {
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
          });
        },
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.withOpacity(0.1),
          ),
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(16.0),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 150,

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
                        scannedBarcodes[index],
                        style: TextStyle(
                          fontFamily: 'Muller',

                          color: Colors.black,
                          fontSize: 12.0,

                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 150.0,),

              Expanded(
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(),
                  child: Center(
                    child: Text(
                      "₹20",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,

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
          IconButton(onPressed: (){}, icon: Icon(Icons.info_outline))
        ],
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        elevation: 0,
        title: Text("AutoCart",style: TextStyle(
          fontFamily: 'Battery',
          fontWeight: FontWeight.bold
        ),),
      ),
      body: ListView.builder(

        itemCount: scannedBarcodes.length,
        itemBuilder: (context, index) {
          return item(index);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(

        onPressed: (){

        },
        tooltip: 'Pay',
        icon: Icon(Icons.fast_forward),
        label: Text("Pay"),
        backgroundColor: Colors.lightGreenAccent,
        /*onPressed: (){},
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        tooltip: 'Pay',
        backgroundColor: Colors.lightGreenAccent,
        child: Icon(
            Icons.fast_forward,
          size: 30,
        ),*/
      ),
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
      player.play(AssetSource('beep-04.mp3'));
      scannedBarcodes.add(barcode);
      setState(() {});
      await scanBarcode();

    }
  }
}
