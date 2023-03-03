import 'package:flutter/material.dart';
import 'package:innobiltz/DashboardWidget/View/Dashboardpage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var prescriptionImages = [];
  String base64image = "";
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;

  void getImage() async {
    imageFile = await _picker.pickImage(source: ImageSource.gallery);
    var imageBytes = File(imageFile!.path).readAsBytesSync();
    base64image = base64Encode(imageBytes);
    print("image string: $base64image");
    prescriptionImages.add(imageFile);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return new WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.red,
            title: const Text('Gallery'),
          ),
        ),
        body: SingleChildScrollView(

          child: Container(
            // height: screenHeight,
            child: Column(
              children: [
                prescriptionImages.length > 0
                    ? GridView.count(
                      shrinkWrap: true,
                      physics: PageScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 8.0,
                        children: List.generate(prescriptionImages.length,
                            (index) {
                               final image = prescriptionImages[index];
                          return Container(
                              // color: Colors.amber,
                              child: Image.file(
                                File(image!.path),
                                width: screenwidth * 0.1,
                                height: screenHeight * 0.05,
                                // fit: BoxFit.cover,
                              ),);
                        }))
                    : Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.1,
                        // width: screenwidth * 0.68,
                        child: Text('Upload Image'),
                      ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            getImage();
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.add_a_photo_rounded),
        ),
      ),
    );
  }
}
