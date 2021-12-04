import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'canva_like_page.dart';
import 'shape_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: ChangeNotifierProvider<ShapeProvider>(
        create: (BuildContext context) => ShapeProvider(),
        child: CanvaLikePage(),
      ),
    );
  }
}
