import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innobiltz/LoginWidget/AuthApi.dart';
import 'package:innobiltz/LoginWidget/View/OtpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
    late SharedPreferences pref;

  TextEditingController phoneNo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWith = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.2,
              ),
              Center(
                  child: Text(
                "Enter your Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                controller: phoneNo,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: screenHeight * 0.001),
              SizedBox(
                width: screenWith,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: () async {
                      //  pref = await SharedPreferences.getInstance();
                      //      await pref.setBool('isLogin', true);

                      if (phoneNo.text.length < 10) {
                        Fluttertoast.showToast(
                          msg: "Invalid Phone Number",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
 await AuthApi().sendOtp(context, phoneNo);
                        // AuthApi().sendOtp(context, phoneNo);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen()));
                      }
                    },
                    child: Text('Submit')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
