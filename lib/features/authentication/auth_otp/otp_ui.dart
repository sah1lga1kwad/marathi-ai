import 'package:flutter/material.dart';
import 'package:marathi_ai/features/authentication/auth_firebase.dart';
import 'package:pinput/pinput.dart';

class Otp extends StatefulWidget {
  const Otp({
    super.key,
    required this.username,
    required this.width,
    required this.buttonClicked,
    required this.itemHeight2,
    required this.phone,
  });
  final String phone;
  final String username;
  final double width;
  final bool buttonClicked;
  final double itemHeight2;

  @override
  State<Otp> createState() {
    return _Otp();
  }
}

class _Otp extends State<Otp> {
  @override
  Widget build(buildContext) {
    //User Authentication
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: super.widget.width,
          child: (super.widget.buttonClicked)
              ? const Text(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  'OTP वन टाइम पासवर्ड',
                )
              : const SizedBox(),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: super.widget.width,
          height: super.widget.itemHeight2 * 0.675,
          child: (super.widget.buttonClicked)
              ? Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    height: super.widget.itemHeight2 * 0.55,
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 121, 121, 121)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  onCompleted: (pin) {
                    signInWithOTP(
                      username: super.widget.username,
                      phone: super.widget.phone,
                      otp: pin,
                      context: context,
                    );
                  })
              : const SizedBox(),
        )
      ],
    );
  }
}
