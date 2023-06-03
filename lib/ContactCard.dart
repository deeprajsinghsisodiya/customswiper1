import 'package:flutter/material.dart';
import 'contact.dart';
class ContactCard extends StatelessWidget {
  const ContactCard({required this.borderColor,required this.contact,Key? key}) : super(key: key);
final Color borderColor;
  final Contact contact;
  @override
  Widget build(BuildContext context) {

    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          heightFactor: .9,
          alignment: Alignment.centerLeft,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(contact.name)
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(contact.website)
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(contact.email)
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
