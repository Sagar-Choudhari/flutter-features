import 'dart:io';
import 'package:open_filex/open_filex.dart' as open;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  final String filePath;
  const PdfViewer(this.filePath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            shape: const StadiumBorder(),
            onPressed: () {
              open.OpenFilex.open(filePath);
            },
            label: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.remove_red_eye),
                ),
                Text('View in Pdf Viewer')
              ],
            ),
          ),
        ),
        body: SfPdfViewer.file(File(filePath)));
  }
}
