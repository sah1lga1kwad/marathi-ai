//Firebase Auth
import 'dart:math';
import 'dart:developer' as dartdevpkg;

import 'package:firebase_auth/firebase_auth.dart';

//Firebase Cloud
import 'package:cloud_firestore/cloud_firestore.dart';

//Flutter
import 'package:flutter/material.dart';
import 'package:marathi_ai/features/history/history_chat_page.dart';
import 'package:intl/intl.dart';

class ChatHistoryPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ChatHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore
            .collection('/users/${firebaseAuth.currentUser!.uid}/history')
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
//const TODO: Search On Complete KEyboard Down
          return (documents.isEmpty)
              ? const Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 30,
                      ),
                      Text(
                        'No Chat History',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    String historyName = documents[index]['history_name'];

                    // Extract Timestamp object
                    Timestamp timestamp = documents[index]['timestamp'];

                    // Convert Timestamp to DateTime
                    DateTime dateTime = timestamp.toDate();

                    // Format timestamp to display date and time
                    String formattedTimestamp =
                        DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);

                    return Column(
                      children: [
                        if (index == 0)
                          const SizedBox(
                            height: 8,
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2),
                          child: ListTile(
                            tileColor: Color.fromARGB(255, 255, 255, 255),
                            horizontalTitleGap: 25,
                            title: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              historyName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              formattedTimestamp,
                              style: const TextStyle(fontSize: 12),
                            ),
                            leading: Icon(
                              Icons.arrow_right_sharp,
                              color: generateRandomColor(),
                              size: 30,
                            ),
                            // trailing: const Icon(Icons.output_outlined),
                            shape: const Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 245, 245, 245),
                                  width: 1.0),
                            ),
                            onTap: () {
                              // Navigate to chat page if needed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(chatId: documents[index].id),
                                ),
                              );
                            },
                          ),
                        ),
                        if (index == documents.length - 1)
                          const ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'आणखी History नाही',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                );
        },
      ),
    );
  }
}

final strongColors = [
  Colors.black,
];

Color generateRandomColor() {
  final random = Random();
  return strongColors[random.nextInt(strongColors.length)];
}

class FeatureRequestPopup extends StatefulWidget {
  const FeatureRequestPopup({super.key});

  @override
  _FeatureRequestPopupState createState() => _FeatureRequestPopupState();
}

class _FeatureRequestPopupState extends State<FeatureRequestPopup> {
  final _featureRequestController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Feature Request'),
      content: TextField(
        controller: _featureRequestController,
        decoration:
            const InputDecoration(hintText: 'Describe the feature you want'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle feature request submission here
            dartdevpkg
                .log('Feature request: ${_featureRequestController.text}');
            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
