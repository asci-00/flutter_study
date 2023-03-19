import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;

  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "딜리버리",
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: bodyTextColor,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(label: "홈", icon: Icon(Icons.home_outlined)),
          BottomNavigationBarItem(
              label: "음식", icon: Icon(Icons.fastfood_outlined)),
          BottomNavigationBarItem(
              label: "주문", icon: Icon(Icons.receipt_long_outlined)),
          BottomNavigationBarItem(
              label: "프로필", icon: Icon(Icons.person_outlined)),
        ],
      ),
      child: TabBarView(
        controller: controller,
        children: const [
          RestaurantScreen(),
          RestaurantScreen(),
          Center(child: Text('주문')),
          Center(child: Text('프로필')),
        ],
      ),
    );
  }
}
