import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innobiltz/DashboardWidget/View/Dashboardpage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final LocalStorage storage = new LocalStorage('local_store');
  late SharedPreferences pref;


class AuthApi {
  User? user;
  sendOtp(context, phoneNo) async {
    print(phoneNo);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 ${phoneNo.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          storage.setItem('verificationId', verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {}
  }

  verifyOtp(context, smsCode) async {
    try {
      var user = null;
      var verificationId = storage.getItem('verificationId');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await auth.signInWithCredential(credential).then(
        (value) {
          user = FirebaseAuth.instance.currentUser;
        },
      ).whenComplete(
        () async {
          if (user != null) {
                                   pref = await SharedPreferences.getInstance();

     await pref.setBool('isLogin', true);

            Fluttertoast.showToast(
              msg: "You are logged in successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ),
            );
            
          } else {
            Fluttertoast.showToast(
              msg: "Wrong OTP",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
      );
    } catch (e) {
      print('wrong password');
    }
  }
}
