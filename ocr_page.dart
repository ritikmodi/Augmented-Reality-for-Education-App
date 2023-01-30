import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:flutter_ocr/ar.dart';
import '3d.dart';

String text1 = "TEXT";
String res = "";

class OCRPage extends StatefulWidget {
  @override
  _OCRPageState createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  int _ocrCamera = FlutterMobileVision.CAMERA_BACK;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Text Detection (OCR)'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text1,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Center(
                child: RaisedButton(
                  onPressed: _read,
                  color: Colors.lightGreen,
                  child: Text(
                    'Scan text',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _ocrCamera,
        waitTap: true,
      );
      res = texts[0].value.toLowerCase();
      setState(() {
        text1 = texts[0].value;
        Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Ar()));
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text'));
    }
  }
}
