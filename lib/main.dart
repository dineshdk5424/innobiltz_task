import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:innobiltz/DashboardWidget/View/Dashboardpage.dart';
import 'package:innobiltz/LoginWidget/View/AuthPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final LocalStorage storage = new LocalStorage('local_store');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppWrapper(),
    );
  }
}

class AppWrapper extends StatefulWidget {
  AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late SharedPreferences pref;
  bool? isLoggedIn = false;
  
  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = pref.getBool('isLogin');
    });
  }

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      initPreferences();
      // TODO: implement initState
      super.initState();
    }
    return isLoggedIn == true ? DashboardScreen() : AuthScreen();
  }
}
