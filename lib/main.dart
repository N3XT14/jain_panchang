import 'package:flutter/material.dart';
import 'package:jain_panchang/shared/constants/constants.dart';
import 'package:jain_panchang/shared/navigation_drawer/presentation/navigation_drawer.dart';
import 'package:jain_panchang/shared/widgets/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: appBar(context),
        body: const Text('HomeScreen'),
        drawer: const CustomNavigationDrawer(),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconTheme.of(context).copyWith(
        color: AppColors.complexDrawerBlack,
      ),
      title: const CustomText(
        text: 'Jain Panchang',
        color: AppColors.complexDrawerBlack,
      ),
    );
  }
}
