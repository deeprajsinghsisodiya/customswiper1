import 'package:flutter/material.dart';
import 'ContactCard.dart';
import 'PerspectiveItems.dart';
import 'contact.dart';

class PerspectiveListView extends StatefulWidget {
  const PerspectiveListView(this.onTapFrontItem,
      this.onChangeItem,{
    Key? key,
    required this.children,
    required this.itemExtent,
    required this.visualizeditems,
     this.initialIndex=0,
     this.padding=const EdgeInsets.all(0.0),

     this.backItemsShadowColor=Colors.black,
  }) : super(key: key);
final List<Widget> children;
  final double itemExtent;
  final int visualizeditems;
  final int initialIndex;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int> onTapFrontItem;
  final ValueChanged<int> onChangeItem;
  final Color backItemsShadowColor;

  @override
  State<PerspectiveListView> createState() => _PerspectiveListViewState();
}

class _PerspectiveListViewState extends State<PerspectiveListView> {
  late PageController _pageController;
  late double _pagePercent;
  late int _currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1/widget.visualizeditems
    );
    _currentIndex =widget.initialIndex;
    _pagePercent = 0.0;
    _pageController.addListener(_pageListner);

    super.initState();
  }
  @override
  void dispose(){
    _pageController.removeListener(_pageListner);
    _pageController.dispose();
    super.dispose();
  }
void _pageListner() {

    _currentIndex =_pageController.page!.floor();
    _pagePercent =(_pageController.page! - _currentIndex).abs();
    setState(() {

    });

}
  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [

          Padding(
            padding: widget.padding,
            child: PerspectiveItems(
              heightItem: widget.itemExtent,
              currentIndex: _currentIndex,
              children: widget.children,
              generatedItems: widget.visualizeditems-1,
              pagePercent: _pagePercent,

            ),
          ),
          //void page view
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: PageController(viewportFraction: .4),
            physics: const BouncingScrollPhysics(),
            onPageChanged: (value){
              if(widget.onChangeItem != null){
                widget.onChangeItem(value);
              }
          },
            itemCount: widget.children.length,

            itemBuilder: (context, index) {

              return SizedBox();
            }
            ,),
        ],
      );
  }
}







// PageView.builder(
// scrollDirection: Axis.vertical,
// controller: PageController(viewportFraction: .4),
// itemBuilder: (context, index) {
// final contact = Contact.contacts[index];
// final borderColor = Colors.accents[index % Colors.accents.length];
// return ContactCard(
// borderColor: borderColor,
// contact: contact,
// );
// }
// ,),
