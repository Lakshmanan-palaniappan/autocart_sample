import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner_B extends StatefulWidget {
  const Scanner_B({Key? key}) : super(key: key);

  @override
  State<Scanner_B> createState() => _Scanner_BState();
}

class _Scanner_BState extends State<Scanner_B> {
  List<String> scannedBarcodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner"),
      ),
      body: ListView.builder(
        itemCount: scannedBarcodes.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.withOpacity(0.1),
            ),
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(16.0),

            child: Text(
              scannedBarcodes[index],
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20.0,

              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanBarcode,
        tooltip: 'Scan',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> scanBarcode() async {
    final barcode = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );
    if (barcode != '-1') {
      scannedBarcodes.add(barcode);
      setState(() {});
      await scanBarcode();
    }
  }
}
