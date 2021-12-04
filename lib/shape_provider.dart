import 'package:flutter/material.dart';

enum Mode {
  none,
  paint,
  text,
  image,
}

class ShapeProvider extends ChangeNotifier {
  List<int> idList = [];
  int currentId = 1;
  int lastId = 1;
  Mode currentMode = Mode.none;

  Map<int, Color> colorMap = {};
  Map<int, String> textMap = {};
  Map<int, FontWeight> fontWeightMap = {};
  Map<int, Color> textColorMap = {};
  Map<int, double> fontSizeMap = {};
  Map<int, String> imagePathMap = {};

  void addId(int id) {
    idList.add(id);
    notifyListeners();
  }

  void removeId(int id) {
    idList.remove(id);
    notifyListeners();
  }

  void changeCurrentId(int id) {
    currentId = id;
    notifyListeners();
  }

  void incrementLastId() {
    lastId++;
    notifyListeners();
  }

  void changeMode(Mode property) {
    currentMode = property;
    notifyListeners();
  }
  
  void changeColor(Color color) {
    colorMap[currentId] = color;
    notifyListeners();
  }

  void changeText(String text) {
    textMap[currentId] = text;
    notifyListeners();
  }
  
  void changeFontWeight(FontWeight fontWeight) {
    fontWeightMap[currentId] = fontWeight;
    notifyListeners();
  }

  void changeTextColor(Color color) {
    textColorMap[currentId] = color;
    notifyListeners();
  }

  void changeFontSize(double fontSize) {
    fontSizeMap[currentId] = fontSize;
    notifyListeners();
  }

  void changeImagePath(String path) {
    imagePathMap[currentId] = path;
    notifyListeners();
  }
}