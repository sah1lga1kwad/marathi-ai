//Flutter
import 'package:flutter/material.dart';

class VideoWindow extends StatelessWidget {
  const VideoWindow({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.32875,
        width: 380,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurStyle: BlurStyle.outer,
                blurRadius: 10,
                color: Colors.black26)
          ],
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              //https://api.flutter.dev/flutter/widgets/ClipRRect-class.html
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                height: screenHeight * 0.20625,
                width: 340,
                color: Colors.green,
                child: Image.asset(
                    'lib/features/authentication/auth_assets/searchdefault.png',
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 325,
              child: Text(
                'या App क्षमता जाणून घेण्यासाठी हा 2 मिनिटांचा व्हिडिओ पहा',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
