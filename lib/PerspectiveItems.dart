import 'dart:ui';

import 'package:flutter/material.dart';

class PerspectiveItems extends StatelessWidget {
  const PerspectiveItems({Key? key, required this.generatedItems, required this.currentIndex, required this.heightItem, required this.pagePercent, required this.children}) : super(key: key);
final int generatedItems;
  final int currentIndex;
  final double heightItem;
  final double pagePercent;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;

      return Stack(
      fit: StackFit.expand,
      children: List.generate(generatedItems, (index) {
        final invertedIndex =(generatedItems -2)-index;
        final indexPlus = index+1;
        final positionPercent = indexPlus/generatedItems;
        final endPositionPercent = index/generatedItems;
        return (currentIndex>invertedIndex)?_TransformedItems(lerpDouble(.5, 1.0, endPositionPercent)!,(height-heightItem)*positionPercent,(height-heightItem)*endPositionPercent,heightItem: heightItem,factorChange: pagePercent,scale: lerpDouble(.5, 1.0, positionPercent)!,child: children[currentIndex-(invertedIndex+1)],): const SizedBox();
      }),
      );
    },);
  }
}

class _TransformedItems extends StatelessWidget {
  const _TransformedItems(      this.endScale,  this.translateY,  this.endTranslateY, {   required this.child, required this.heightItem, required this.factorChange,required this.scale,Key? key,}) : super(key: key);
  final Widget child ;
  final double heightItem;
  final double factorChange;
  final double scale;
  final double endScale;
  final double translateY;
  final double endTranslateY;




  @override
  Widget build(BuildContext context) {
    return Transform(alignment: Alignment.topCenter,
      transform: Matrix4.identity()..scale(lerpDouble(scale, endScale, factorChange))..translate(0.0,lerpDouble(translateY, translateY, factorChange)!,0.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: heightItem,
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
