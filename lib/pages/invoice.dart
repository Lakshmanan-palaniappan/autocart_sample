import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

class Invoice {
  Future<Uint8List> generateInvoice(List<String> names, List<int> prices, String customerName, String mobileNumber) async {
    final pdf = pw.Document();

    // Load a custom TTF font that supports the Indian Rupee symbol
    final fontData = await rootBundle.load('assets/Roboto-Regular.ttf');
    final ttfFont = pw.Font.ttf(fontData.buffer.asByteData());

    // Load the company logo image
    final logoData = await rootBundle.load('assets/logo.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    // Load the paid seal image
    final sealData = await rootBundle.load('assets/paid_seal.png');
    final sealImage = pw.MemoryImage(sealData.buffer.asUint8List());

    // Get current date and time
    final now = DateTime.now();
    final formattedDateTime = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Company logo and shop details
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 150, // Adjust the width as needed
                      child: pw.Image(logoImage),
                    ),
                    pw.Container(
                      width: 150, // Adjust the width as needed
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'AUTO CART',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            '12/9,west Houston, Columbus',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            'Phone:+61898765434',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                // Invoice title
                pw.Text(
                  'Invoice',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                // Customer details
                pw.Row(
                  children: [
                    pw.Text(
                      'Customer Name: $customerName',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Text(
                      'Mobile Number: $mobileNumber',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                // Table for items and prices
                pw.Table.fromTextArray(
                  headers: ['Item', 'Price'],
                  data: List<List<String>>.generate(
                    names.length,
                        (index) => [
                      names[index],
                      '₹${prices[index]}', // Indian Rupee symbol (Unicode character)
                    ],
                  ),
                  border: null, // No border for the table
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black, // Text color
                  ), // Header style
                  cellStyle: pw.TextStyle(
                    font: ttfFont,
                    color: PdfColors.black, // Text color
                  ), // Cell style with custom font
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColors.lime, // Header background color
                  ),
                  cellAlignment: pw.Alignment.center, // Align cell content to center
                ),
                pw.SizedBox(height: 20),
                // Total
                pw.Text(
                  'Total: ₹${prices.reduce((value, element) => value + element)}',
                  style: pw.TextStyle(font: ttfFont, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                // Date and time
                pw.Text(
                  'Date and Time: $formattedDateTime',
                  style: pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 20),
                // Footer
                pw.Divider(),
                // Payment status with paid seal
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Payment Status: Paid',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.brown, // Text color
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Image(sealImage, width: 50), // Paid seal image
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Thank you for your purchase!',
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.black, // Text color
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> savedPdfFile(String filename, Uint8List byteList) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory != null) {
      final output = directory.path;
      var filepath = "$output/$filename.pdf";
      final file = File(filepath);
      try {
        await file.writeAsBytes(byteList);
        print("PDF file saved at: $filepath");
        await OpenFile.open(filepath);
      } catch (e) {
        print("Error saving or opening PDF file: $e");
      }
    } else {
      print("Unable to get the directory for saving PDF.");
    }
  }

}

