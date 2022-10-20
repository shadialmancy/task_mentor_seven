import 'package:flutter/material.dart';
import 'package:task_mentor_seven/screen/wishlist.dart';
import 'package:task_mentor_seven/shared%20themes/colors.dart';
import 'package:task_mentor_seven/shared%20themes/textstyle.dart';

class CustomDrawPage extends StatefulWidget {
  const CustomDrawPage({Key? key}) : super(key: key);

  @override
  State<CustomDrawPage> createState() => _CustomDrawPageState();
}

class _CustomDrawPageState extends State<CustomDrawPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(color: black.withOpacity(0.5)),
            TextButton(
                style: TextButton.styleFrom(fixedSize: Size(size.width, 50)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishListPage(),
                      ));
                },
                child: Text(
                  "Wishlist",
                  style: headerBoldText(20),
                )),
            Divider(
              color: black.withOpacity(0.5),
            )
          ],
        ),
      ),
    );
  }
}
