import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class PdfViewerScreen extends StatelessWidget {
  final String filePath;

  const PdfViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            OpenFile.open(filePath);
          },
          child: Text('Open PDF'),
        ),
      ),
    );
  }
}
