import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Overlapped Carousel',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Overlapped Carousel'),
    );
  }
}


final problemidProvider = StateNotifierProvider<ProblemidNotifier, double>((ref) => ProblemidNotifier());

class ProblemidNotifier extends StateNotifier<double> {
  ProblemidNotifier() : super(0.0);
  set value(double text) =>
      state = text; // value and text are just name can be any word , ///state can be used directly in place of value in comment dialog
}

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  //Generate a list of widgets. You can use another way
  List<Widget> widgets = List.generate(
    14,
        (index) => index==1||index==0||index==13||index==12? SizedBox():ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
      child:
      // Container(color: Colors.primaries[ index % Colors.primaries.length],),

      Image.asset(
        'assets/images/${index-2}.jpg', //Images stored in assets folder
        fit: BoxFit.fill,
      ),
    ),
  );
List<String> l =['1fffffffffffffffffffffffffffffffffffffffff','2gggggggggggggggggggggggggggggggggggggggggggg','3ddddddddddddddddddddddddddddddddddd','4ddddddddddddddddddddddddddddddddddddddddddddd','mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm5','6','7','8','9gbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb','10','11','12','13','14','15'];
  @override
  Widget build(BuildContext context) {
    print('888888888888888888888888888888888888888888888888888888888888888888888888888${ref.watch(problemidProvider)}');
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.blue,
      //Wrap with Center to place the carousel center of the screen
      body: Center(
        //Wrap the OverlappedCarousel widget with SizedBox to fix a height. No need to specify width.
        child: Column(
          children: [
            SizedBox(
              height: min(screenWidth / 2.5 * (16 / 9),screenHeight*.9),
              child: OverlappedCarousel(
                widgets: widgets, //List of widgets
                currentIndex: 2,
                onClicked: (index) {print('index of the card sss$index');
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text("You clicked at $index"),
                  //   ),
                  // );
                },
              ),
            ),

Text(l[ref.watch(problemidProvider).toInt()])
          ],
        ),
      ),
    );
  }
}




class OverlappedCarousel extends ConsumerStatefulWidget {
  final List<Widget> widgets;
  final Function(int) onClicked;
  final int? currentIndex;

  OverlappedCarousel(
      {required this.widgets, required this.onClicked, this.currentIndex});

  // @override
  // ConsumerState<availableProblems> createState() => _availableProblemsState();
  @override
  ConsumerState<OverlappedCarousel> createState()=> _OverlappedCarouselState();


}

class _OverlappedCarouselState extends ConsumerState<OverlappedCarousel> {
  double currentIndex = 2;

  @override
  void initState() {
    if (widget.currentIndex != null)
      currentIndex = widget.currentIndex!.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                var indx = currentIndex - details.delta.dx * 0.02;
                if (indx >= 1 && indx <= widget.widgets.length - 3)
                  currentIndex = indx;
              });
            },
            onPanEnd: (details) {
              setState(() {
                currentIndex = currentIndex.ceil().toDouble();
                ref.read(problemidProvider.notifier).value=currentIndex;
              });
            },
            child: OverlappedCarouselCardItems(
              cards: List.generate(
                widget.widgets.length,
                    (index) => CardModel(id: index, child: widget.widgets[index]),
              ),
              centerIndex: currentIndex,
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
              onClicked: widget.onClicked,
            ),
          );
        },
      ),
    );
  }
}
class CardModel {
  final int id;
  double zIndex;
  final Widget? child;

  CardModel({required this.id, this.zIndex = 0.0, this.child});
}

class OverlappedCarouselCardItems extends StatelessWidget {
  final List<CardModel> cards;
  final Function(int) onClicked;
  final double centerIndex;
  final double maxHeight;
  final double maxWidth;

  OverlappedCarouselCardItems({
    required this.cards,
    required this.centerIndex,
    required this.maxHeight,
    required this.maxWidth,
    required this.onClicked,
  });

  double getCardPosition(int index) {
    final double center = maxWidth / 2;
    final double centerWidgetWidth = maxWidth / 4;
    final double basePosition = center - centerWidgetWidth / 2 - 12;
    final distance = centerIndex - index;

    final double nearWidgetWidth = centerWidgetWidth / 5 * 4;
    final double farWidgetWidth = centerWidgetWidth / 5 * 3;

    if (distance == 0) {
      return basePosition;
    } else if (distance.abs() > 0.0 && distance.abs() <= 1.0) {
      if (distance > 0) {
        return basePosition - nearWidgetWidth * distance.abs();
      } else {
        return basePosition + centerWidgetWidth * distance.abs();
      }
    } else if (distance.abs() >= 1.0 && distance.abs() <= 2.0) {
      if (distance > 0) {
        return (basePosition - nearWidgetWidth) -
            farWidgetWidth * (distance.abs() - 1);
      } else {
        return (basePosition + centerWidgetWidth + nearWidgetWidth) +
            farWidgetWidth * (distance.abs() - 2) -
            (nearWidgetWidth - farWidgetWidth) *
                ((distance - distance.floor()));
      }
    } else {
      if (distance > 0) {
        return (basePosition - nearWidgetWidth) -
            farWidgetWidth * (distance.abs() - 1);
      } else {
        return (basePosition + centerWidgetWidth + nearWidgetWidth) +
            farWidgetWidth * (distance.abs() - 2);
      }
    }
  }

  double getCardWidth(int index) {
    final double distance = (centerIndex - index).abs();
    final double centerWidgetWidth = maxWidth / 3.2;
    final double nearWidgetWidth = centerWidgetWidth / 5 * 4.2;
    final double farWidgetWidth = centerWidgetWidth / 5 * 3.2;

    if (distance >= 0.0 && distance < 1.0) {
      return centerWidgetWidth -
          (centerWidgetWidth - nearWidgetWidth) * (distance - distance.floor());
    } else if (distance >= 1.0 && distance < 2.0) {
      return nearWidgetWidth -
          (nearWidgetWidth - farWidgetWidth) * (distance - distance.floor());
    } else {
      return farWidgetWidth;
    }
  }

  Matrix4 getTransform(int index) {
    final distance = centerIndex - index;

    var transform = Matrix4.identity()
      ..setEntry(3, 2, 0.007)
    // ..rotateY(-0.25 * distance)
      ..scale(1.25, 1.25, 1.25);
    if (index == centerIndex) transform..scale(1.05, 1.05, 1.05);
    return transform;
  }

  Widget _buildItem(CardModel item) {
    final int index = item.id;
    final width = getCardWidth(index);
    final height = maxHeight - 20 * (centerIndex - index).abs();
    final position = getCardPosition(index);
    final verticalPadding = width * 0.05 * (centerIndex - index).abs();

    return Positioned(
      left: position,
      child: Transform(
        transform: getTransform(index),
        alignment: FractionalOffset.center,
        child: InkWell(hoverColor: Colors.amber,onTap: () {
          if(centerIndex==index){
          onClicked(index);}
        },
          child: Container(
            width: width.toDouble(),
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            height: height > 0 ? height : 0,
            child: item.child,
          ),
        ),
      ),
    );
  }

  List<Widget> _sortedStackWidgets(List<CardModel> widgets) {
    for (int i = 0; i < widgets.length; i++) {
      if (widgets[i].id == centerIndex) {
        widgets[i].zIndex = widgets.length.toDouble();
      } else if (widgets[i].id < centerIndex) {
        widgets[i].zIndex = widgets[i].id.toDouble();
        print('< ${widgets[i].zIndex}');
      } else {
        widgets[i].zIndex =
            widgets.length.toDouble() - widgets[i].id.toDouble();
        print('> ${widgets[i].zIndex}');
      }
    }
    widgets.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    return widgets.map((e) {
      double distance = (centerIndex - e.id).abs();
      print(distance);
      if (distance >= 0 && distance <= 3){ print('distance inside if $distance');
        return _buildItem(e);}
      else
        return Container();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none,
        children: _sortedStackWidgets(cards),
      ),
    );
  }
}

// // Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// // for details. All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.
// import 'package:flutter/material.dart';
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PageviewGallery(),
//     );
//   }
// }
//
//
// class PageviewGallery extends StatefulWidget {
//   @override
//   _PageviewGalleryState createState() => _PageviewGalleryState();
// }
// class _PageviewGalleryState extends State<PageviewGallery> {
//   final PageController ctrl = PageController(
//     viewportFraction: 0.55,
//   );
//   int currentPage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//           body: Stack(
//             children: [
//               PageView.builder(
//                   controller: ctrl,
//                   itemCount: 8,
//                   physics: const BouncingScrollPhysics(),
//                   itemBuilder: (context, int index) {
//                     // Active page
//                     if(index==0){return SizedBox(height: 100,);}
//                     bool active = index == currentPage;
//                     return _buildStoryPage(active,context);
//                   }),
//             ],
//           ),
//         ));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     ctrl.addListener(() {
//       int pos = ctrl.page!.round();
//       if (currentPage != pos) {
//         {
//           setState(() {
//             currentPage = pos;
//           });
//         }
//       }
//     });
//   }
// }
//
// _buildStoryPage( bool active,  context) {
//   // Animated Properties
//   final double blur = active ? 30 : 0;
//   final double offset = active ? 20 : 0;
//   final double top = active ? 400 : 200;
//   return Center(
//       child: AnimatedContainer(height: MediaQuery.of(context).size.height*.1*top/100,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeOutQuint,
//         // margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color :Colors.red,
//             boxShadow: [BoxShadow(color: Colors.black87, blurRadius: blur, offset: Offset(offset, offset))]),
//       ),
//     );
// }
//
//
//
//
//
//
//
//

//
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
//
// import 'dart:math';
// import 'package:flutter/material.dart';
//
// import '../../carousel.dart';
//
//
// typedef OnCarouselTap = Function(int);
//
// class Carousel extends StatefulWidget {
//   final dynamic type;
//
//   ///The scroll Axis of Carousel
//   final Axis axis;
//
//   final int initialPage;
//
//   dynamic updatePositionCallBack;
//
//   /// call back function triggers when gesture tap is registered
//   final OnCarouselTap onCarouselTap;
//
//   /// This feild is required.
//   ///
//   /// Defines the height of the Carousel
//   final double height;
//
//   /// Defines the width of the Carousel
//   final double width;
//
//   final List<Widget> children;
//
//   ///  callBack function on page Change
//   final onPageChange;
//
//   /// Defines the Color of the active Indicator
//   final Color activeIndicatorColor;
//
//   ///defines type of indicator to carousel
//   final dynamic indicatorType;
//
//   final bool showArrow;
//
//   ///defines the arrow colour
//   final Color arrowColor;
//
//   ///choice to show indicator
//   final bool showIndicator;
//
//   /// Defines the Color of the non-active Indicator
//   final Color unActiveIndicatorColor;
//
//   /// Paint the background of indicator with the color provided
//   ///
//   /// The default background color is Color(0xff121212)
//   final Color indicatorBackgroundColor;
//
//   /// Defines if the carousel should wrap once you reach the end or if your at the begining and go left if it should take you to the end
//   ///
//   /// The default behavior is to allow wrapping
//   final bool allowWrap;
//
//   /// Provide opacity to background of the indicator
//   ///
//   /// An opacity of 1.0 is fully opaque. An opacity of 0.0 is fully transparent
//   /// (i.e., invisible).
//   ///
//   /// The default value of opacity is 0.5 nothing is initialised.
//   ///
//
//   final double indicatorBackgroundOpacity;
//   dynamic updateIndicator;
//   PageController controller;
//   int currentPage = 0;
//
//   GlobalKey key;
//
//   Carousel(
//       {this.key,
//         @required this.height,
//         @required this.width,
//         @required this.type,
//         this.axis,
//         this.showArrow,
//         this.arrowColor,
//         this.onPageChange,
//         this.showIndicator = true,
//         this.indicatorType,
//         this.indicatorBackgroundOpacity,
//         this.unActiveIndicatorColor,
//         this.indicatorBackgroundColor,
//         this.activeIndicatorColor,
//         this.allowWrap = true,
//         this.initialPage,
//         this.onCarouselTap,
//         @required this.children})
//       : assert(initialPage >= 0 && initialPage < children.length,
//   "intialPage must be a int value between 0 and length of children"),
//         super(key: key) {
//     this.createState();
//   }
//   @override
//   createState() {
//     return _CarouselState();
//   }
// }
//
// class _CarouselState extends State<Carousel> {
//   int position = 0;
//   double animatedFactor;
//   double offset;
//   final GlobalKey<RendererState> rendererKey1 = new GlobalKey();
//   final GlobalKey<RendererState> rendererKey2 = new GlobalKey();
//   @override
//   void initState() {
//     // TODO: implement initState
//     widget.updatePositionCallBack = updatePosition;
//     super.initState();
//   }
//
//   @override
//   dispose() {
//     widget.controller.dispose();
//     super.dispose();
//   }
//
//   updatePosition(int index) {
//     if (widget.controller.page.round() == widget.children.length - 1) {
//       rendererKey2.currentState.updateRenderer(false);
//     }
//     if (widget.controller.page.round() == widget.children.length - 2) {
//       rendererKey2.currentState.updateRenderer(false);
//     }
//     if (widget.controller.page.round() == 1) {
//       rendererKey1.currentState.updateRenderer(false);
//     }
//     if (widget.controller.page.round() == 0) {
//       rendererKey1.currentState.updateRenderer(false);
//     }
//   }
//
//   scrollPosition(dynamic updateRender, {String function}) {
//     updateRender(false);
//
//     if ((widget.controller.page.round() == 0 && function == "back") ||
//         widget.controller.page == widget.children.length - 1 &&
//             function != "back") {
//       if (widget.allowWrap) {
//         widget.controller.jumpToPage(
//             widget.controller.page.round() == 0 && function == "back"
//                 ? widget.children.length - 1
//                 : 0);
//       }
//     } else {
//       widget.controller.animateToPage(
//           (function == "back"
//               ? (widget.controller.page.round() - 1)
//               : (widget.controller.page.round() + 1)),
//           curve: Curves.easeOut,
//           duration: const Duration(milliseconds: 500));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     offset = (widget.type.toString().toLowerCase() == "slideswiper" ||
//         widget.type == Types.slideSwiper)
//         ? 0.8
//         : 1.0;
//     Size size = MediaQuery.of(context).size;
//     ScreenRatio.setScreenRatio(size: size);
//     animatedFactor =
//     widget.axis == Axis.horizontal ? widget.width : widget.height;
//     widget.controller = new PageController(
//       initialPage: widget.initialPage ?? 0,
//       keepPage: true,
//       viewportFraction: offset,
//     );
//     dynamic carousel = _getCarousel(widget);
//     return Container(
//         child: Stack(
//           children: <Widget>[
//             Center(
//                 child: GestureDetector(
//                   child: carousel,
//                   onTap: () {
//                     if (widget.onCarouselTap != null) {
//                       widget.onCarouselTap(widget.controller.page?.round());
//                     }
//                   },
//                 )),
//             Center(
//               child: Container(
//                   height: widget.height,
//                   child: widget.showArrow == null || widget.showArrow == false
//                       ? SizedBox()
//                       : Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[]..addAll([
//                       "back",
//                       "forward"
//                     ].map((f) =>
//                         Renderer(f == 'back' ? rendererKey1 : rendererKey2,
//                                 (updateRender, active) {
//                               return Visibility(
//                                 visible: widget.allowWrap
//                                     ? true
//                                     : (f == 'back' &&
//                                     widget?.controller?.page
//                                         ?.round() ==
//                                         0 ||
//                                     f == 'forward' &&
//                                         widget.controller.page
//                                             ?.round() ==
//                                             widget.children.length - 1
//                                     ? false
//                                     : true),
//                                 child: GestureDetector(
//                                   onTapUp: (d) {
//                                     scrollPosition(updateRender, function: f);
//                                   },
//                                   onTapDown: (d) {
//                                     updateRender(true);
//                                   },
//                                   onLongPress: () {
//                                     scrollPosition(updateRender, function: f);
//                                   },
//                                   child: Container(
//                                     height: widget.height / 2,
//                                     width: 40.0,
//                                     color: active
//                                         ? Color(0x77121212)
//                                         : Colors.transparent,
//                                     child: Icon(
//                                       f == "back"
//                                           ? Icons.arrow_back_ios
//                                           : Icons.arrow_forward_ios,
//                                       color: active
//                                           ? Colors.white
//                                           : widget.arrowColor != null
//                                           ? widget.arrowColor
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }))),
//                   )),
//             ),
//             Center(
//               child: widget.showIndicator != true
//                   ? SizedBox()
//                   : Container(
//                 height: widget.height,
//                 alignment: Alignment.bottomCenter,
//                 child: Wrap(
//                   children: <Widget>[
//                     Container(
//                       width: widget.width,
//                       alignment: Alignment.bottomCenter,
//                       color: (widget.indicatorBackgroundColor ??
//                           Color(0xff121212))
//                           .withOpacity(
//                           widget.indicatorBackgroundOpacity ?? 0.5),
//                       padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
//                       child: Indicator(
//                         indicatorName: widget.indicatorType,
//                         selectedColor: widget.activeIndicatorColor,
//                         unSelectedColor: widget.unActiveIndicatorColor,
//                         totalPage: widget.children.length,
//                         width: widget.width,
//                         controller: widget.controller,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
//
//   _getCarousel(Carousel widget) {
//     dynamic carousel;
//     dynamic type = widget.type.runtimeType == Types
//         ? widget.type
//         : _getType(widget.type.toLowerCase());
//
//     switch (type) {
//       case Types.simple:
//         {
//           carousel = SimpleCarousel(widget);
//         }
//         break;
//       case Types.slideSwiper:
//         {
//           carousel = SlideSwipe(widget);
//         }
//         break;
//
//       case Types.xRotating:
//         {
//           carousel = XcarouselState(widget);
//         }
//         break;
//       case Types.yRotating:
//         {
//           carousel = RotatingCarouselState(widget);
//         }
//         break;
//       case Types.zRotating:
//         {
//           carousel = ZcarouselState(widget);
//         }
//         break;
//       case Types.multiRotating:
//         {
//           carousel = MultiAxisCarouselState(widget);
//         }
//         break;
//     // default:
//     //   carousel = SimpleCarousel(widget);
//     //   break;
//     }
//     return carousel;
//   }
// }
//
// _getType(String type) {
//   switch (type) {
//     case "simple":
//       {
//         return Types.simple;
//       }
//       break;
//     case "slideswiper":
//       {
//         return Types.slideSwiper;
//       }
//       break;
//
//     case "xrotating":
//       {
//         return Types.xRotating;
//       }
//       break;
//     case "yrotating":
//       {
//         return Types.yRotating;
//       }
//       break;
//     case "zrotating":
//       {
//         return Types.zRotating;
//       }
//       break;
//     case "multirotating":
//       {
//         return Types.multiRotating;
//       }
//       break;
//   }
//
//
//
// class SlideSwipe extends StatelessWidget {
//   int currentPage;
//   bool initial;
//   final Carousel props;
//
//   SlideSwipe(this.props);
//
//   initiate(index) {
//     try {
//       currentPage = props.controller.initialPage.round();
//     } catch (e) {
//       print("exception here => $e");
//     }
//     double value;
//     if (index == currentPage - 1 && initial) value = 1.0;
//     if (index == currentPage && initial) value = 0.0;
//     if (index == currentPage + 1 && initial) {
//       value = 1.0;
//       initial = false;
//     }
//     return value;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     currentPage = 0;
//     initial = true;
//     int count = props.children.length;
//     Widget carouserBuilder = PageView.builder(
//         scrollDirection: props.axis,
//         controller: props.controller,
//         itemCount: count,
//         onPageChanged: (i) {
//           props.updatePositionCallBack(i);
//           if (props.onPageChange != null) {
//             props.onPageChange(i);
//           }
//           currentPage = i;
//         },
//         itemBuilder: (context, index) => builder(index, props.controller));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           height: props.height,
//           width: props.width,
//           child: props.axis == Axis.horizontal
//               ? carouserBuilder
//               : Container(
//             child: carouserBuilder,
//           ),
//         ),
//       ],
//     );
//   }
//
//   builder(int index, PageController controller1) {
//     return AnimatedBuilder(
//       animation: controller1,
//       builder: (context, child) {
//         double value = 1.0;
//         value = initial
//             ? initiate(index) ?? controller1.page! - index
//             : controller1.page! - index;
//         value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
//         return Opacity(
//           opacity: 0,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Center(
//                 child: Container(
//                   height: (props.height -
//                       (props.axis == Axis.vertical
//                           ? props.height / 5
//                           : 0.0)) *
//                       (props.axis == Axis.vertical ? 1.0 : value),
//                   width: props.width * value,
//                   child: props.children[index],
//                   alignment: Alignment.center,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//
//
// class StackedListView extends StatefulWidget {
//   @override
//   _StackedListViewState createState() => _StackedListViewState();
// }
//
// class _StackedListViewState extends State<StackedListView> {
//   final pagecontroller =PageController(
//     viewportFraction: 0.55,
//   );
//
//   double currentIndex = 0;
//   int  currentPage =0;
//   void coffeelistner(){
//     setState(() {
//       currentIndex = pagecontroller.page!;
//     });
//   }
//   List<Color> items = [
//
//     Colors.greenAccent,
//     Colors.pink,
//     Colors.deepOrange,
//
//     Colors.tealAccent,
//     Colors.greenAccent,
//     Colors.amber,
//     Colors.brown,
//   ];
//
//
//   @override
//   void initState() {super.initState();
//   // TODO: implement initState
//   pagecontroller.addListener(coffeelistner);
//
//   pagecontroller.addListener(() {
//     int pos = pagecontroller.page!.round();
//     if (currentPage != pos) {
//       {
//         setState(() {
//           currentPage = pos;
//         });
//       }
//     }
//   });
//
//   }
//
//   @override
//   void dispose() {
//     pagecontroller.removeListener(coffeelistner);
//
//     pagecontroller.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stacked List View'),
//       ),
//       body: Stack(
//         children:[
//           Positioned(top: 0,left: 0,right: 0,height: 100,
//               child: Container(color: Colors.cyanAccent,)),
//
//           PageView.builder(reverse: false,clipBehavior: Clip.antiAlias,onPageChanged: (value) {
//           },
//             // padEnds: true,
//             pageSnapping: true,
//             allowImplicitScrolling: true,
//             controller: pagecontroller,
//             scrollDirection: Axis.horizontal,
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               log('${currentPage}');
//               if(index==0){return SizedBox(height: 100,);}
//               // if(index==1){return SizedBox(height: 100,);}
//               print(currentIndex-index+1);
//               var result = currentIndex-index+1;
//               bool active = index == currentPage;
//               bool scal = index-1 == currentPage;
//               bool opacitya =index-1 == currentPage;
//               bool opacitya1 =index+1 == currentPage;
//
//               bool sizes =index-1 == currentPage;
//               bool sizes1 =index+1 == currentPage;
//               // if(result==0){result=1;}else if(result==1){result=2;}else if(result==2){result=1;}
//               final value = result*-0.2+1; ///Height where list items dissapper and if value is high they will reappear (-0.3)
//               final opacity =value.clamp(0.0,1.0);
//               final double top = active ? 400 : 200;
//               final double x = scal ? value-.4: value;
//               final double y = opacitya ? .60 : opacitya1? .60 :1;
//               final double q = sizes ? 50:100 ;
//
//               return Transform(alignment: Alignment.center,
//                   transform: Matrix4.identity()
//                   // ..translate(1.0,2.0)
//                   // ..setEntry(3, 2, 0.001)
//                   // ..translate(0.0,x.abs())
//                   //  ..scale(x)
//                   ,
//                   child: Opacity(opacity: y,child: Center(child:
//                   // Container(height: 200,color: items[index-1],)
//                   AnimatedContainer(height: MediaQuery.of(context).size.height*.1*top/100, width:  MediaQuery.of(context).size.height*.1*top/100,
//                     duration: Duration(milliseconds: 500),
//                     curve: Curves.easeOutQuint,
//                     // margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color :Colors.primaries[index % Colors.primaries.length],
//                         boxShadow: [BoxShadow(color: Colors.black87,)]),
//                   )
//
//                   )));
//             },)
//         ],
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: StackedListView(),
//   ));
// }


//
//
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
//
// class StackedListView extends StatefulWidget {
//   @override
//   _StackedListViewState createState() => _StackedListViewState();
// }
//
// class _StackedListViewState extends State<StackedListView> {
//   final pagecontroller =PageController(
//     viewportFraction: 0.35,
//   );
//
//   double currentIndex = 0;
//  int  currentPage =0;
//   void coffeelistner(){
// setState(() {
//   currentIndex = pagecontroller.page!;
// });
//   }
//   List<Color> items = [
//
//     Colors.greenAccent,
//   Colors.pink,
//   Colors.deepOrange,
//
//     Colors.tealAccent,
//     Colors.greenAccent,
//     Colors.amber,
//     Colors.brown,
//   ];
//
//
// @override
//   void initState() {super.initState();
//     // TODO: implement initState
//   pagecontroller.addListener(coffeelistner);
//
//   pagecontroller.addListener(() {
//     int pos = pagecontroller.page!.round();
//     if (currentPage != pos) {
//       {
//         setState(() {
//           currentPage = pos;
//         });
//       }
//     }
//   });
//
//   }
//
//   @override
//   void dispose() {
//     pagecontroller.removeListener(coffeelistner);
//
//     pagecontroller.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stacked List View'),
//       ),
//       body: Stack(
//         children:[
//          Positioned(top: 0,left: 0,right: 0,height: 100,
//              child: Container(color: Colors.cyanAccent,)),
//
//          PageView.builder(reverse: false,clipBehavior: Clip.antiAlias,onPageChanged: (value) {
//          },
//            // padEnds: true,
//            pageSnapping: true,
//            controller: pagecontroller,
//            scrollDirection: Axis.horizontal,
//            itemCount: items.length,
//            itemBuilder: (context, index) {
//               log('${currentPage}');
//              if(index==0){return SizedBox(height: 100,);}
//               // if(index==1){return SizedBox(height: 100,);}
//              print(currentIndex-index+1);
//              var result = currentIndex-index+1;
//               bool active = index == currentPage;
//               bool scal = index-1 == currentPage;
//              // if(result==0){result=1;}else if(result==1){result=2;}else if(result==2){result=1;}
//              final value = result*-0.2+1; ///Height where list items dissapper and if value is high they will reappear (-0.3)
//              final opacity =value.clamp(0.0,1.0);
//               final double top = active ? 400 : 200;
//               final double x = scal ? value-.3: value;
//
//            return Transform(alignment: Alignment.center,
//                transform: Matrix4.identity()..row0
//                  // ..setEntry(3, 2, 0.001)
//              // ..translate(2.0,x.abs())
//               ..scale(x)
//                ,
//                child: Opacity(opacity: opacity,child: Center(child:
//                // Container(height: 200,color: items[index-1],)
//              Center(
//       child: AnimatedContainer(height: MediaQuery.of(context).size.height*.1*top/100,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeOutQuint,
//         // margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color :Colors.red,
//             boxShadow: [BoxShadow(color: Colors.black87,)]),
//       ),
//     )
//
//                )));
//          },)
//         ],
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: StackedListView(),
//   ));
// }
