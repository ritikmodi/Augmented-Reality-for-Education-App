import 'dart:io';
import 'package:flutter/material.dart';
import 'package:model_viewer/model_viewer.dart';
import 'ocr_page.dart';



class Ar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton (
                 icon: Icon(Icons.arrow_back), 
                 onPressed: () { 
                      Navigator.pop(context);
                 },
        ),
          title: Text("3D Model"),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: ModelViewer(
          backgroundColor: Colors.black,
          src: 'assets/$res.glb',
          alt: "Earth",
          ar: true,
          autoRotate: true,
          cameraControls: true,
        ),
      )
    );
  }
}
