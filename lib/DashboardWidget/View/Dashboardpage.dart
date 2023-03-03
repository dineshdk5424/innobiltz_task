import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innobiltz/CommonWidget/SpinLoader.dart';
import 'package:innobiltz/DashboardWidget/View/Mapview.dart';
import 'dart:convert';
import 'dart:async';

import 'package:innobiltz/LoginWidget/AuthApi.dart';
import 'package:innobiltz/UserWidget/View/UserPage.dart';
import 'package:innobiltz/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SharedPreferences pref;

  var userList;
  bool isLoading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  


    getValue();
  }

  getValue() async {
         

    this.setState(() {
      isLoading = true;
    });
     pref = await SharedPreferences.getInstance();
      await pref.setBool('isLogin', true);
    var result = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/users"),
      headers: {"Content-Type": "application/json"},
    );
    var result1 = json.decode(result.body);
    this.setState(() {
      userList = result1;
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _selectedIndex == 1
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserScreen()))
        : Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return new WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.red,
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                  onPressed: () async {
                         pref = await SharedPreferences.getInstance();

                    await pref.setBool('isLogin', false);
                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyApp()));
                  },
                  icon: Icon(Icons.logout)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: !isLoading
                  ? Container(
                      width: screenwidth,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = userList[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                  title: Text('${data['username']}'),
                                  subtitle: Text('${data['email']}'),
                                  leading: Container(
                                      width: screenwidth * 0.10,
                                      child: Image.asset('assets/user.png')),
                                  onTap: () {
                                    storage.setItem('select_user', data);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MapviewScreen()));
                                  },
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.location_on,
                                    ),
                                  )),
                            ),
                          );
                        },
                      ),
                    )
                  : SpinLoader()),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
