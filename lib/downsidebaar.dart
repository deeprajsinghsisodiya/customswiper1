

import 'dart:developer';

import 'package:flutter/material.dart';

class StackedListView extends StatefulWidget {
  @override
  _StackedListViewState createState() => _StackedListViewState();
}

class _StackedListViewState extends State<StackedListView> {
  final pagecontroller =PageController(
    viewportFraction: 0.35,
  );

  double currentIndex = 0;
  int  currentPage =0;
  void coffeelistner(){
    setState(() {
      currentIndex = pagecontroller.page!;
    });
  }
  List<Color> items = [

    Colors.greenAccent,
    Colors.pink,
    Colors.deepOrange,

    Colors.tealAccent,
    Colors.greenAccent,
    Colors.amber,
    Colors.brown,
  ];


  @override
  void initState() {super.initState();
  // TODO: implement initState
  pagecontroller.addListener(coffeelistner);

  pagecontroller.addListener(() {
    int pos = pagecontroller.page!.round();
    if (currentPage != pos) {
      {
        setState(() {
          currentPage = pos;
        });
      }
    }
  });

  }

  @override
  void dispose() {
    pagecontroller.removeListener(coffeelistner);

    pagecontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stacked List View'),
      ),
      body: Stack(
        children:[
          Positioned(top: 0,left: 0,right: 0,height: 100,
              child: Container(color: Colors.cyanAccent,)),

          PageView.builder(reverse: true,
            controller: pagecontroller,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              log('${currentPage}');
              if(index==0){return SizedBox(height: 100,);}
              print(currentIndex-index+1);
              var result = currentIndex-index+1;
              bool active = index == currentPage;
              bool scal = index+1 == currentPage;
              // if(result==0){result=1;}else if(result==1){result=2;}else if(result==2){result=1;}
              final value = result*-0.2+1; ///Height where list items dissapper and if value is high they will reappear (-0.3)
              final opacity =value.clamp(0.0,1.0);
              final double top = active ? 400 : 200;
              final double x = scal ? MediaQuery.of(context).size.height/2*(1-value): MediaQuery.of(context).size.height/1*(1-value);

              return Transform(alignment: Alignment.center,
                  transform: Matrix4.identity()
                  // ..setEntry(3, 2, 0.001)..
                    ..translate(2.0,x.abs())
                  //  ..scale(x)

                  ,
                  child: Opacity(opacity: opacity,child: Center(child:

                  // Container(height: 200,color: items[index-1],)
                  Center(
                    child: AnimatedContainer(height: MediaQuery.of(context).size.height*.1*top/100,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutQuint,
                      // margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color :Colors.red,
                          boxShadow: [BoxShadow(color: Colors.black87,)]),
                    ),
                  )

                  )));
            },)
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StackedListView(),
  ));
}
