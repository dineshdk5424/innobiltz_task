import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:innobiltz/DashboardWidget/View/Dashboardpage.dart';
import 'package:innobiltz/LoginWidget/AuthApi.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var otp;
  @override
  Widget build(BuildContext context) {
    double screenWith = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.2,
            ),
            Center(
                child: Text(
              'OTP Verification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            OtpTextField(
              numberOfFields: 6,
              showFieldAsBox: true,
              onSubmit: (value){
                print(value);
                this.setState(() {
                  otp = value;
                });

              },
            ),
            SizedBox(height: screenHeight* 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),onPressed: () async {
              //  Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => DashboardScreen()));
                        
              await AuthApi().verifyOtp(context, otp);
              
            }, child: Text('Verify Otp'))
          ],
        ),
      ),
    );
  }
}
