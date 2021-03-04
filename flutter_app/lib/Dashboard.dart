import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/BottomNavigation/Add_Hunger_Spot.dart';
import 'package:flutter_app/BottomNavigation/NGOs.dart';
import 'package:flutter_app/BottomNavigation/Settings.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'BottomNavigation/Donate_Food.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Donation',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State {
  int currentIndex;
  BuildContext context;
  @override
  void initState() {
    super.initState();

    currentIndex = 0;
  }

  logout()async{
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>Login()), (route) => false);
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget>list=[
    Container(),
    NGOs(),
    Settings()
  ];

  SpeedDial _speedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 24.0),
      curve: Curves.easeInBack,
      backgroundColor: Colors.orange.shade700,
      heroTag: 'add',
      children: [
        SpeedDialChild(
          backgroundColor: Colors.orange.shade400,
          child: Icon(Icons.add),
          label: 'Donate Food',
          labelBackgroundColor: Colors.grey.shade400,
          onTap:() => Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Donate_Food())),
        ),
        SpeedDialChild(
            backgroundColor: Colors.orange.shade400,
            child: Icon(Icons.add_a_photo),
            label: 'Add Hunger Spot',
            labelBackgroundColor: Colors.grey.shade400,
          onTap:() => Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Add_Hunger_Spot())),

        ),
      ],

    );
  }

  @override
  Widget build(BuildContext context) {
    this.context=context;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Text('City'),
              IconButton(icon: Icon(Icons.location_on_outlined),padding: EdgeInsets.all(0.0), onPressed: ()async{
                // await logout();
              }),
            ],
          )
        ],
        title: Text('Food Donation'),
        centerTitle: true,
      ),
      floatingActionButton: _speedDial(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.2,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        currentIndex: currentIndex,
        hasInk: true,
        inkColor: Colors.black12,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: changePage,
        items: [
          BubbleBottomBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(
              Icons.dashboard,
              color: Colors.black,

            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Colors.orangeAccent,
            ),
            title: Text('Dashboard'),

          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(
              Icons.account_balance_sharp,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.account_balance_sharp,
              color: Colors.orangeAccent,
            ),
            title: Text('NGOs'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(
              Icons.group,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.group,
              color: Colors.orangeAccent,
            ),
            title: Text('Profile'),
          ),
        ],
      ),
      body: list[currentIndex]
    );
  }
}
