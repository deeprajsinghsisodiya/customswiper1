import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageviewGallery(),
    );
  }
}


class PageviewGallery extends StatefulWidget {
  @override
  _PageviewGalleryState createState() => _PageviewGalleryState();
}
class _PageviewGalleryState extends State<PageviewGallery> {
  final PageController ctrl = PageController(
    viewportFraction: 0.55,
  );
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                  controller: ctrl,
                  itemCount: 8,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, int index) {
                    // Active page
                    if(index==0){return SizedBox(height: 100,);}
                    bool active = index == currentPage;
                    return _buildStoryPage(active,context);
                  }),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      int pos = ctrl.page!.round();
      if (currentPage != pos) {
        {
          setState(() {
            currentPage = pos;
          });
        }
      }
    });
  }
}

_buildStoryPage( bool active,  context) {
  // Animated Properties
  final double blur = active ? 30 : 0;
  final double offset = active ? 20 : 0;
  final double top = active ? 400 : 200;
  return Center(
      child: AnimatedContainer(height: MediaQuery.of(context).size.height*.1*top/100,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        // margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color :Colors.red,
            boxShadow: [BoxShadow(color: Colors.black87, blurRadius: blur, offset: Offset(offset, offset))]),
      ),
    );
}
