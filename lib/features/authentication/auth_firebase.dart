import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marathi_ai/features/appbuilder.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String _verificationId = "";

Future<void> verifyPhoneNumber(String phoneNumber) async {
  try {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  } catch (e) {
    log("Error during verification: ${e.toString()}");
  }
}

void verificationCompleted(PhoneAuthCredential credential) async {
  try {
    await _auth.signInWithCredential(credential);
    log('USER SIGNED IN');
  } catch (e) {
    log("Error during sign-in with credential: ${e.toString()}");
  }
}

void verificationFailed(FirebaseAuthException e) {
  log("Verification failed: ${e.message}");
}

void codeSent(String verificationId, int? resendToken) {
  _verificationId = verificationId;
  log("Verification code sent. Verification ID: $_verificationId");
  // Display OTP input field or handle it as needed
}

void codeAutoRetrievalTimeout(String verificationId) {
  log("Verification code timed out");
}

Future<void> signInWithOTP({
  required String username,
  required String phone,
  required String otp,
  required BuildContext context,
}) async {
  try {
    if (username.isEmpty) {
      // Show an error message or prompt the user to enter their username
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter your username.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp,
    );
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await _auth.signInWithCredential(credential);

    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final QuerySnapshot querySnapshot =
        await users.where('phone_number', isEqualTo: phone).get();
    bool userExists = querySnapshot.docs.isNotEmpty;

    if (!userExists) {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid);
      await docRef.set({
        "name": username,
        'phone_number': phone,
      });

      // await docRef.collection('history').add({
      //   'history_name': '12345',`
      // });
    } else {
      final DocumentSnapshot userDoc = querySnapshot.docs.first;
      await userDoc.reference.update({
        "name": username,
      });
    }

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const AppBuilder()),
    );

    log('USER SIGNED IN WITH OTP');
  } catch (e) {
    log("Error during sign-in with OTP: ${e.toString()}");
  }
}

//TODO:Logging Framework - Up in Firebase + Crashinalytics