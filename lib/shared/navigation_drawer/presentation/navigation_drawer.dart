import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jain_panchang/features/calendar/presentation/calendar.dart';
import 'package:jain_panchang/features/dashboard/presentation/dashboard.dart';
import 'package:jain_panchang/shared/constants/constants.dart';
import 'package:jain_panchang/shared/navigation_drawer/data/repository.dart';
import 'package:jain_panchang/shared/navigation_drawer/domain/entities.dart';
import 'package:jain_panchang/shared/widgets/widgets.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({super.key});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  int selectedIndex = -1;
  bool isExpanded = false;
  final List<NavigationDrawerModel> navItems = NavigationDrawerData.ndd;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: SizedBox(
        width: width,
        child: row(),
      ),
    );
  }

  Widget row() {
    return Row(
      children: [isExpanded ? blackIconTiles() : backIconMenu()],
    );
  }

  Widget blackIconTiles() {
    return Container(
      width: 200,
      color: AppColors.complexDrawerBlack,
      child: Column(
        children: [
          controlTile(),
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (BuildContext context, int index) {
                NavigationDrawerModel cdm = navItems[index];
                // bool selected = selectedIndex == index;
                return ExpansionTile(
                  onExpansionChanged: (z) {
                    setState(() {
                      selectedIndex = z ? index : -1;
                    });
                    handleMenuItemClick(index);
                  },
                  leading: Icon(cdm.icon, color: Colors.white),
                  title: CustomText(
                    text: cdm.title,
                    color: Colors.white,
                  ),
                  // trailing: cdm.submenus.isEmpty
                  //     ? null
                  //     : Icon(
                  //         selected
                  //             ? Icons.keyboard_arrow_up
                  //             : Icons.keyboard_arrow_down,
                  //         color: Colors.white,
                  //       ),
                  // children: cdm.submenus.map((subMenu) {
                  //   return sMenuButton(subMenu, false);
                  // }).toList(),
                );
              },
            ),
          ),
          accountTile()
        ],
      ),
    );
  }

  Widget controlTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: ListTile(
        leading: const FlutterLogo(),
        title: const CustomText(
          text: "Jain Panchang",
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        onTap: expandOrShrinkDrawer,
      ),
    );
  }

  Widget backIconMenu() {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: 100,
      color: AppColors.complexDrawerBlack,
      child: Column(
        children: [
          controlButton(),
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    handleMenuItemClick(index);
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Icon(navItems[index].icon, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          accountButton(),
        ],
      ),
    );
  }

  Widget controlButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: InkWell(
        onTap: expandOrShrinkDrawer,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: const FlutterLogo(
            size: 40,
          ),
        ),
      ),
    );
  }

  // Widget sMenuButton(String subMenu, bool isTitle) {
  //   return InkWell(
  //     onTap: () {
  //       //handle the function
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: CustomText(
  //         text: subMenu,
  //         fontSize: isTitle ? 17 : 14,
  //         color: isTitle ? Colors.white : Colors.grey,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  Widget accountButton({bool usePadding = true}) {
    return Padding(
      padding: EdgeInsets.all(usePadding ? 8 : 0),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.white70,
          // image: DecorationImage(
          //   image: NetworkImage(Urls.avatar2),
          //   fit: BoxFit.cover,
          // ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget accountTile() {
    return Container(
      color: AppColors.complexDrawerBlueGrey,
      child: ListTile(
        leading: accountButton(usePadding: false),
        title: const CustomText(
          text: "Yash Oswal",
          color: Colors.white,
        ),
        subtitle: const CustomText(
          text: "Binghamton, NY",
          color: Colors.white70,
        ),
      ),
    );
  }

  void expandOrShrinkDrawer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void handleMenuItemClick(int index) {
    // Perform the desired action here based on the index
    switch (index) {
      case 0:
        // Dashboard menu item click handler
        if (kDebugMode) {
          print('Dashboard clicked');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        // Calendar menu item click handler
        if (kDebugMode) {
          print('Calendar clicked');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarScreen()),
        );
        break;
    }
  }
}
