import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'ocr_page.dart';



class Model3D extends StatefulWidget {
  @override
  _Model3DState createState() => _Model3DState();
}

class _Model3DState extends State<Model3D> {
  Object obj;

  @override
  void initState() {

    obj = Object(fileName: "assets/JUPITER/JUPITER.obj");
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("3D object"),
      ),
      body: Container(
        child: Cube(
          onSceneCreated: (Scene scene) {
            scene.world.add(obj);
            scene.camera.zoom = 15;
          },
        ),
      ),
    );
  }
}
