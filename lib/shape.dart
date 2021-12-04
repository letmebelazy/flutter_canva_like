import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_canva_like/shape_provider.dart';
import 'package:provider/provider.dart';

class Shape extends StatelessWidget {
  final int id;
  Shape(this.id);

  @override
  Widget build(BuildContext context) {
    ShapeProvider provider = Provider.of<ShapeProvider>(context);
    double position = id.toDouble() * 30.0;

    return Positioned(
      top: position,
      left: position,
      child: GestureDetector(
        onTap: () {
          if (provider.currentId != id) {
            provider.changeCurrentId(id);
          }
          if (provider.currentMode == Mode.text) {
            provider.changeMode(Mode.none);
          }
        },
        child: Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
            border: Border.all(color: provider.currentId == id ? Colors.teal : Colors.black),
            color: provider.colorMap.containsKey(id) ? provider.colorMap[id] : Colors.transparent,
            image: DecorationImage(
              image: FileImage(File(provider.imagePathMap.containsKey(id) ? provider.imagePathMap[id]! : '')),
              fit: BoxFit.fill
            ),
          ),
          child: Text(provider.textMap.containsKey(id) ? provider.textMap[id]! : '', style: TextStyle(
            fontWeight: provider.fontWeightMap.containsKey(id) ? provider.fontWeightMap[id]: FontWeight.normal,
            color: provider.textColorMap.containsKey(id) ? provider.textColorMap[id] : Colors.black,
            fontSize: provider.fontSizeMap.containsKey(id) ? provider.fontSizeMap[id] : 14.0,
          ),),
        ),
      )
    );
  }
}
