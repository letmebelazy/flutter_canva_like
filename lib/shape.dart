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
        child: Stack(
          children: [
            Draggable(
              child: ShapePiece(id),
              feedback: ShapePiece(id),
              childWhenDragging: Container(),
              onDragEnd: (d) {
                final Size size = MediaQuery.of(context).size;
                final parentPosition = CanvaLikePage.stackKey.globalPaintBounds;
                final Position position = Position();
                if (parentPosition == null) return;
                position.dx = d.offset.dx - parentPosition.left;
                position.dy = d.offset.dy - parentPosition.top;
                if (position.dx > 0 && position.dy > 0 && position.dx < size.width - 70 && position.dy < size.height - 150 - 70 - 102 - 30) {
                  p.changePosition(position);
                }
              },
            ),
            Positioned(
                top: 0.0,
                left: 0.0 ,
                child: GestureDetector(
                  onPanStart: (d) {
                    p.fixStartingOffset(d.localPosition);
                  },
                  onPanUpdate: (d) {
                    var startingLength = Length(70, 70);
                    // var position = Position();
                    if (p.lengthMap[p.currentId] != null) {
                      // startingLength = p.lengthMap[p.currentId]!;
                    }

                    final increasedWidth = p.startingOffset.dx - d.localPosition.dx;
                    final increasedHeight = p.startingOffset.dy - d.localPosition.dy;
                    // position.dx = d.localPosition.dx;
                    // position.dy = d.localPosition.dy;

                    p.changeLength(Length(startingLength.width + increasedWidth, startingLength.height + increasedHeight));
                    // p.changePosition(position);
                  },
                  child: CircleAvatar(radius: 6.0, backgroundColor: Colors.teal,)))
            // Positioned(bottom: 0.0, left: 0.0 ,child: CircleAvatar(radius: 5.0, backgroundColor: Colors.teal,)),
            // Positioned(bottom: 0.0, right: 0.0 ,child: CircleAvatar(radius: 5.0, backgroundColor: Colors.teal,)),
            // Positioned(top: 0.0, right: 0.0 ,child: CircleAvatar(radius: 5.0, backgroundColor: Colors.teal,)),
          ],
        ),
      )
    );
  }
}

class ShapePiece extends StatelessWidget {
  final int id;
  ShapePiece(this.id);

  @override
  Widget build(BuildContext context) {
    ShapeProvider p = Provider.of<ShapeProvider>(context);
    return Container(
      margin: const EdgeInsets.all(3.0),
      width: p.lengthMap[p.currentId] == null ? 70.0 : p.lengthMap[p.currentId]!.width,
      height: p.lengthMap[p.currentId] == null ? 70.0 : p.lengthMap[p.currentId]!.height,
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
      return renderObject!.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}
//
// class ZoomHandle extends StatelessWidget {
//   final ShapeProvider p;
//   ZoomHandle(this.p);
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 20,
//       left: 20,
//       child: SizedBox(
//         width: p.lengthMap[p.currentId] == null ? 80.0 : p.lengthMap[p.currentId]!.width + 10,
//         height: p.lengthMap[p.currentId] == null ? 80.0 : p.lengthMap[p.currentId]!.height + 10,
//         child:  Stack(
//           children: [
//             Center(
//               child: Container(
//                 width: p.lengthMap[p.currentId] == null ? 70.0 : p.lengthMap[p.currentId]!.width,
//                 height: p.lengthMap[p.currentId] == null ? 70.0 : p.lengthMap[p.currentId]!.height,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.teal.withOpacity(0.8), width: 1.5),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 0.0,
//               left: 0.0,
//               child: CircleAvatar(radius: 7.0, backgroundColor: Colors.teal.withOpacity(0.8),),
//             ),
//             Positioned(
//               bottom: 0.0,
//               left: 0.0,
//               child: Draggable(
//                 feedback: CircleAvatar(radius: 7.0, backgroundColor: Colors.teal.withOpacity(0.8),),
//                 child: CircleAvatar(radius: 7.0, backgroundColor: Colors.teal.withOpacity(0.8),),
//                 onDragEnd: (d) {
//                   // 핸들의 위치 변경 외에 핸들에 움직임에 따라 길이가 같이 변동되도록 해야함
//                   // 그러려면 실시간으로 값의 변화를 반영해줘야 함
//                   // 초기값을 설정해놓고 범위 바깥에 가는 순간 모든 값을 초기값으로 복원시키며 return 해야할 듯
//                   final size = MediaQuery.of(context).size;
//                   final parentPosition = CanvaLikePage.stackKey.globalPaintBounds;
//                   final position = Position();
//                   if (parentPosition == null) return;
//                   position.dx = d.offset.dx - parentPosition.left;
//                   position.dy = d.offset.dy - parentPosition.top;
//                   if (position.dx > 0 && position.dy > 0 && position.dx < size.width - 70 && position.dy < size.height - 150 - 70 - 102 - 30) {
//                     p.changePosition(position);
//                   }
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 0.0,
//               right: 0.0,
//               child: CircleAvatar(radius: 7.0, backgroundColor: Colors.teal.withOpacity(0.8),),
//             ),
//             Positioned(
//               top: 0.0,
//               right: 0.0,
//               child: CircleAvatar(radius: 7.0, backgroundColor: Colors.teal.withOpacity(0.8),),
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }
