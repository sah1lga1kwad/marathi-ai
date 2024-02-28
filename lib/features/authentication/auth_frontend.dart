import 'package:flutter/material.dart';
import 'package:marathi_ai/features/authentication/auth_otp/otp_ui.dart';
import 'package:marathi_ai/features/authentication/auth_firebase.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required});

  @override
  State<AuthPage> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  double animatedcontainerHeight = 0.41;
  bool buttonClicked = false;
  double itemHeight2 = 0.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double itemWidth = screenWidth * 0.7;

    //User Authentication
    return Scaffold(
      body: Stack(
        children: [
          // *Humanoid Image*
          SizedBox(
            // height: ((screenHeight * 90) /
            //     100), //Image Height at Number Verify Page: 67.5% of the screen height
            width: screenWidth,
            child: Image.asset(
              'lib/features/authentication/auth_assets/humanoid_auth.svg',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            // *Bottom Login White Curved Card*
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                //Animation White Container Code
                height: screenHeight *
                    animatedcontainerHeight, //White Container Height 42.5% of the screen
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60.0)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: (screenHeight * 0.05)), // Top Spacer
                    // App Logo
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: (buttonClicked == false)
                          ? Image.asset(
                              'lib/features/authentication/auth_assets/marathi-ai-logo-login.png',
                            )
                          : const SizedBox(),
                    ),
                    const Spacer(),

                    // Label : Phone Number
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: const Text(
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        'Phone Number फोन नंबर',
                      ),
                    ),
                    // Phone Number Text Field
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: (buttonClicked == false)
                          ? TextField(
                              controller: phoneNumber,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '+91 '),
                              style: const TextStyle(fontSize: 18),
                            )
                          : Text(
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.left,
                              phoneNumber.text,
                            ),
                    ),
                    const Spacer(),
                    Fname(
                      username: username,
                      width: itemWidth,
                      itemHeight: itemHeight2,
                      buttonClicked: buttonClicked,
                    ), // Name Text Field
                    // const Spacer(),
                    Otp(
                      phone: phoneNumber.text,
                      username: username.text,
                      width: itemWidth,
                      buttonClicked: buttonClicked,
                      itemHeight2: itemHeight2,
                    ),
                    (buttonClicked == true) ? const Spacer() : const SizedBox(),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: (buttonClicked == false)
                          ? const Text(
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              'By clicking "Confirm", you agree to the Terms of conditions and Privacy Policy')
                          : const SizedBox(),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: (buttonClicked == true)
                                ? ElevatedButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          setState(
                                            () {
                                              buttonClicked = false;
                                              animatedcontainerHeight = 0.425;
                                              itemHeight2 = screenHeight * 0.0;
                                            },
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'Restart',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          SizedBox(
                            width: screenWidth * 0.05,
                          ),
                          Expanded(
                            child: (buttonClicked == false)
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (phoneNumber.text != "") {
                                          await verifyPhoneNumber(
                                              phoneNumber.text);
                                          setState(
                                            () {
                                              buttonClicked = true;
                                              animatedcontainerHeight = 0.50;
                                              itemHeight2 = screenHeight * 0.1;
                                            },
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF8C52FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          // signInWithOTP('123456');
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF8C52FF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'Start App!',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: (screenHeight * 0.05), //Bottom Spacer
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Fname extends StatefulWidget {
  const Fname({
    super.key,
    required this.width,
    required this.buttonClicked,
    required this.itemHeight,
    required this.username,
  });

  final TextEditingController username;
  final double width;
  final double itemHeight;
  final bool buttonClicked;

  @override
  State<Fname> createState() {
    return _Fname();
  }
}

class _Fname extends State<Fname> {
  @override
  Widget build(buildContext) {
    //User Authentication
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: super.widget.width,
          // height: super.widget.itemHeight * 0.275,
          child: (super.widget.buttonClicked)
              ? const Text(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  'Name नाव',
                )
              : const SizedBox(),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: super.widget.width,
          height: super.widget.itemHeight * 1,
          child: (super.widget.buttonClicked)
              ? TextField(
                  controller: super.widget.username,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Name & Surname'),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
