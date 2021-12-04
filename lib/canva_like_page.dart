import 'package:flutter/material.dart';
import 'package:flutter_canva_like/shape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'shape_provider.dart';

class CanvaLikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShapeProvider provider = Provider.of<ShapeProvider>(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Canva Like Page', style: TextStyle(
            color: Colors.black
          ),),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      for (int i = 0; i < provider.idList.length; i++) ...[
                        Shape(provider.idList[i]),
                      ]
                    ],
                  )),
                Divider(indent: 20.0, endIndent: 20.0, thickness: 0.5, height: 0.0, color: Colors.grey,),
                ModeSelector(provider),
                ToolBox(provider),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: FloatingActionButton(
            backgroundColor: Colors.orange,
            child: Icon(Icons.add),
            onPressed: () {
              provider.addId(provider.lastId);
              provider.changeCurrentId(provider.lastId);
              provider.incrementLastId();

              if (provider.currentMode == Mode.text) {
                provider.changeMode(Mode.none);
              }
            },
          ),
        ),
      ),
    );
  }
}

class ToolBox extends StatelessWidget {
  final ShapeProvider provider;
  final List<Color> colorList = [Colors.black, Colors.red, Colors.green, Colors.blue, Colors.yellow];
  ToolBox(this.provider);

  @override
  Widget build(BuildContext context) {
    switch (provider.currentMode) {
      case Mode.paint:
        return Container(
          width: double.infinity,
          height: 100.0,
          color: Colors.black.withOpacity(0.7),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (Color color in colorList) ...[
                    GestureDetector(
                      onTap: () {
                        if (provider.idList.contains(provider.currentId)) {
                          provider.changeColor(color);
                        }},
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: color == provider.colorMap[provider.currentId] ? 3.5 : 1.0),
                          borderRadius: BorderRadius.circular(25.0),
                          color: color,
                        ),
                      ),
                    )
                  ]
                ]
          ));
      case Mode.text:
        return Container(
          height: 100.0,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                initialValue: provider.textMap[provider.currentId] == null ? '' : provider.textMap[provider.currentId],
                onChanged: (value) {
                  provider.changeText(value);
                },
                decoration: InputDecoration(
                  hintText: '여기에 입력하세요'
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: provider.fontWeightMap[provider.currentId] == FontWeight.bold ? Colors.grey : Colors.transparent
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.format_bold),
                        onPressed: () {
                          if (provider.fontWeightMap[provider.currentId] == FontWeight.bold) {
                            provider.changeFontWeight(FontWeight.normal);
                          } else {
                            provider.changeFontWeight(FontWeight.bold);
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (Color color in colorList) ...[
                        GestureDetector(
                          onTap: () {
                            if (provider.idList.contains(provider.currentId)) {
                              provider.changeTextColor(color);
                            }
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            color: color,
                          ),
                        )
                      ]
                    ],
                  ),
                  Slider(
                    onChanged: (value) {
                      if (provider.idList.contains(provider.currentId)) {
                        provider.changeFontSize(value);
                      }
                    },
                    value: provider.fontSizeMap[provider.currentId] == null ? 14.0 : provider.fontSizeMap[provider.currentId]!,
                    min: 10.0,
                    max: 30.0,
                    divisions: 20,
                    activeColor: Colors.black87,
                    inactiveColor: Colors.black87,
                  ),
                ],
              ),
            ],
          ),
        );
      case Mode.image:
        return Container(
          width: double.infinity,
          height: 100.0,
          color: Colors.black.withOpacity(0.7),
          child: TextButton(
            onPressed: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
              provider.changeImagePath(image!.path);
            },
            child: Text('이미지 선택', textScaleFactor: 1.2, style: TextStyle(
              color: Colors.white
            ),),
          ),
        );
      default:
        return Container(
          width: double.infinity,
          height: 100.0,
          color: Colors.black.withOpacity(0.7),
          child: Center(child: Text(
            provider.idList.isEmpty ? '아이템을 생성해주세요' : '사용할 모드를 선택해주세요',
            textScaleFactor: 1.2,
            style: TextStyle(
            color: Colors.white
          ),
          ),),
        );
    }
  }
}

class ModeSelector extends StatelessWidget {
  final ShapeProvider provider;
  ModeSelector(this.provider);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              if (provider.idList.contains(provider.currentId)) {
                provider.changeMode(Mode.paint);
              }
            },
            child: Text('페인트', textScaleFactor: 1.5, style: TextStyle(
                fontWeight: provider.currentMode == Mode.paint ? FontWeight.bold : FontWeight.normal
            ),),
          ),
          GestureDetector(
            onTap: () {
              if (provider.idList.contains(provider.currentId)) {
                provider.changeMode(Mode.text);
              }
            },
            child: Text('텍스트', textScaleFactor: 1.5, style: TextStyle(
                fontWeight: provider.currentMode == Mode.text ? FontWeight.bold : FontWeight.normal
            ),),
          ),
          GestureDetector(
            onTap: () {
              if (provider.idList.contains(provider.currentId)) {
                provider.changeMode(Mode.image);
              }
            },
            child: Text('이미지', textScaleFactor: 1.5, style: TextStyle(
                fontWeight: provider.currentMode == Mode.image ? FontWeight.bold : FontWeight.normal
            ),),
          ),
          GestureDetector(
            onTap: () {
              provider.removeId(provider.currentId);
              provider.changeMode(Mode.none);
            },
            child: Text('삭제', textScaleFactor: 1.5, style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    );
  }
}
