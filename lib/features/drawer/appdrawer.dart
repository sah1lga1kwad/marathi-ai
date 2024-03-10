//Flutter
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marathi_ai/features/authentication/auth_frontend.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  TextEditingController userName = TextEditingController(text: "Nana ");

  TextEditingController phoneNumber =
      TextEditingController(text: "+918779959863");

  @override
  Widget build(BuildContext context) {
    Future<void> userData() async {
      //Firebase
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          userName.text = data["name"];
          phoneNumber.text = data["phone_number"];

          // ...
        },
        onError: (e) => log("Error getting document: $e"),
      );
    }

    userData();

    /// users/docs(ID - AuthiD current User) / -> name - phone_number

    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
      // TODO: Pop Current Push - Login
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const AuthPage();
          },
        ),
      );
    }

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'lib/features/authentication/auth_assets/marathi-ai-logo-login-white.png',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Account Details',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Icon(
                      Icons.arrow_right_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
                const Text(
                  'Name नाव',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                TextField(
                  controller: userName,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    'Phone Number फोन नंबर',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                TextField(
                  controller: phoneNumber,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                ),
              ],
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Actions',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Icon(
                      Icons.arrow_right_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
                Text(
                  'Terms of Use',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Licenses',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Developer Details',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'App Details',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Actions',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Icon(
                      Icons.arrow_right_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: signOut,
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
