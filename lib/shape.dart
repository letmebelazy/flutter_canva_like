import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_canva_like/canva_like_page.dart';
import 'package:flutter_canva_like/shape_provider.dart';
import 'package:provider/provider.dart';

class Shape extends StatelessWidget {
  final int id;
  Shape(this.id);

  @override
  Widget build(BuildContext context) {
    ShapeProvider p = Provider.of<ShapeProvider>(context);

    return Positioned(
      left: p.positionMap[id] == null ? id.toDouble() * 30 : p.positionMap[id]!.dx,
      top: p.positionMap[id] == null ? id.toDouble() * 30 : p.positionMap[id]!.dy,
      child: GestureDetector(
        onTap: () {
          if (p.currentId != id) {
            p.changeCurrentId(id);
          }
          if (p.currentMode == Mode.text) {
            p.changeMode(Mode.none);
          }
        },
        onPanCancel: () {
          if (p.currentId != id) {
            p.changeCurrentId(id);
          }
          if (p.currentMode == Mode.text) {
            p.changeMode(Mode.none);
          }
        },
        child: Draggable(
          child: ShapePiece(p, id),
          feedback: ShapePiece(p, id),
          childWhenDragging: Container(),
          onDragEnd: (d) {
            final size = MediaQuery.of(context).size;
            final parentPosition = CanvaLikePage.stackKey.globalPaintBounds;
            final position = Position();
            print(WidgetsBinding.instance!.window.padding.bottom);
            if (parentPosition == null) return;
            position.dx = d.offset.dx - parentPosition.left;
            position.dy = d.offset.dy - parentPosition.top;
            if (position.dx > 0 && position.dy > 0 && position.dx < size.width - 70 && position.dy < size.height - 150 - 70 - 102 - 30) {
              p.changePosition(position);
            }
          },
        ),
      )
    );
  }
}

class ShapePiece extends StatelessWidget {
  final ShapeProvider p;
  final int id;
  ShapePiece(this.p, this.id);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 70.0,
      decoration: BoxDecoration(
        border: Border.all(color: p.currentId == id ? Colors.teal : Colors.black),
        color: p.colorMap.containsKey(id) ? p.colorMap[id] : Colors.transparent,
        image: DecorationImage(
            image: FileImage(File(p.imagePathMap.containsKey(id) ? p.imagePathMap[id]! : '')),
            fit: BoxFit.fill
        ),
      ),
      child: Text(p.textMap.containsKey(id) ? p.textMap[id]! : '', style: TextStyle(
        fontWeight: p.fontWeightMap.containsKey(id) ? p.fontWeightMap[id]: FontWeight.normal,
        color: p.textColorMap.containsKey(id) ? p.textColorMap[id] : Colors.black,
        fontSize: p.fontSizeMap.containsKey(id) ? p.fontSizeMap[id] : 14.0,
      ),),
    );
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}