import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
class Scanner_B extends StatefulWidget {
  const Scanner_B({super.key});

  @override
  State<Scanner_B> createState() => _Scanner_BState();
}

class _Scanner_BState extends State<Scanner_B> {
  String barcode='unknown';
  /*void initState() {
    super.initState();
    ScanB();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner"),

      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.amber,
              child: Text("Products"),

            ),
            Expanded(
              child: GestureDetector(
                onTap: ScanB,
                child: Container(
                  color: Colors.blue.withOpacity(0.1),
                  child: Center(
                    child: Text(
                      "Tap to Scan",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

              //TextButton(onPressed: ScanB, child: Text("scan")),






        ),

    );

  }
  Future<void> ScanB() async{
    final barcode= await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "cancel",
        true,

        ScanMode.BARCODE,

    );
    setState((){
      this.barcode=barcode;
    });
    ScanB();
  }



}



