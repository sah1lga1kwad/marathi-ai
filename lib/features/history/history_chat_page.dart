//TODO: History Chat Cannot Generate Data
//TODO: Diff Storage of Marathi & English Outputs - Reduce Queries to Translate.Google - Chats[]English - Chats[]Marathi
//Try Catch Blocks for Gemini & trasnlate And Pop Ups Accordingly

//Firebase Auth
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

//Firebase Cloud
import 'package:cloud_firestore/cloud_firestore.dart';

//Flutter
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:marathi_ai/features/translate/translate.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controller = TextEditingController();
  bool _loading = false;
  List<Content> chats = [];
  String currentHistoryId = '';
  int numLines = 0;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);

  @override
  void initState() {
    super.initState();
    // Load data from Firestore when the page is created
    loadDataFromFirestore();
  }

  Future<void> loadDataFromFirestore() async {
    try {
      loading = true;

      // Fetch data from Firestore
      final querySnapshot = await firestore
          .collection(
              '/users/${FirebaseAuth.instance.currentUser!.uid}/history/${widget.chatId}/messages')
          .orderBy('timestamp', descending: false)
          .get();

      chats.clear();

      for (var messageDoc in querySnapshot.docs) {
        Map<String, dynamic> messageData = messageDoc.data();

        chats.add(Content(
          role: messageData['role'],
          parts: [Parts(text: messageData['content'])],
        ));
      }

      loading = false;
    } catch (e) {
      // Handle errors
      log("Error loading data from Firestore: $e");
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    final gemini = Gemini.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat History Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              reverse: true,
              child: ListView.builder(
                itemBuilder: chatItem,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chats.length,
                reverse: false,
              ),
            ),
          )),
          if (loading) const LinearProgressIndicator(),
          Card(
            margin: const EdgeInsets.all(12),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.100,
                    ),
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Search प्रश्न विचार',
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        focusColor: Colors.white,
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      maxLines: null,
                      onChanged: (String e) {
                        setState(() {
                          numLines = '\n'.allMatches(e).length + 1;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: IconButton(
                      hoverColor: Colors.black,
                      onPressed: () async {
                        if (controller.text.isNotEmpty) {
                          currentHistoryId = super.widget.chatId;

                          final searchedText = controller.text;
                          chats.add(Content(
                              role: 'user',
                              parts: [Parts(text: searchedText)]));
                          controller.clear();
                          loading = true;

                          try {
                            gemini.chat(chats).then((e) {
                              chats.add(Content(
                                  role: 'model',
                                  parts: [Parts(text: e?.output)]));
                              loading = false;

                              FirebaseFirestore firestore =
                                  FirebaseFirestore.instance;
                              final FirebaseAuth firebaseAuth =
                                  FirebaseAuth.instance;
                              final currentUser = firestore
                                  .collection('/users')
                                  .doc(firebaseAuth.currentUser!.uid);

                              currentUser
                                  .collection('history')
                                  .doc(currentHistoryId)
                                  .collection('messages')
                                  .add({
                                "role": 'user',
                                'content': searchedText,
                                'timestamp': FieldValue.serverTimestamp(),
                              }).then((value) {
                                currentUser
                                    .collection('history')
                                    .doc(currentHistoryId)
                                    .collection('messages')
                                    .add({
                                  "role": 'model',
                                  'content': e?.output,
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                              });
                            });
                          } catch (e) {
                            log("Gemini Error $e");
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future translated(Content content, int index) async {
    final Content content = chats[index];

    Future translatedUserText;
    String detectLanguageUser = await detectLanguage(
        content.parts?.lastOrNull!.text ?? "Cannot Generate Data");
    String detectLanguageModel = await detectLanguage(
        content.parts?.lastOrNull!.text ?? "Cannot Generate Data");

    if (content.role == 'user') {
      if (detectLanguageUser == "en") {
        translatedUserText = translateText(
            content.parts?.lastOrNull?.text ?? 'cannot generate data!',
            'en',
            'mr');
        return translatedUserText;
      } else {
        return content.parts?.lastOrNull!.text ?? "Cannot Generate Data";
      }
    } else if (content.role == 'model') {
      if (detectLanguageModel == "en") {
        translatedUserText = translateText(
            content.parts?.lastOrNull?.text ?? 'cannot generate data!',
            'en',
            'mr');
        return translatedUserText;
      } else {
        return content.parts?.lastOrNull!.text ?? "Cannot Generate Data";
      }
    } else {
      return 'Not Role: User';
    }
  }

  Widget chatItem(BuildContext context, int index) {
    final Content content = chats[index];

    return FutureBuilder(
      future: translated(chats[index], index),
      builder: (context, data) {
        if (!data.hasData) {
          return const Center(child: LinearProgressIndicator());
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: (content.role == 'model')
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 15,
                            color: Colors.purpleAccent,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            (content.role == 'model') ? "MARATHI AI" : 'role',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ), //?? 'role'
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust radius as needed
                          // ... other decoration properties
                          color: const Color.fromARGB(31, 187, 187, 187),
                        ),
                        child: Markdown(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          data: data.data ??
                              'Generation Failed', // content.parts?.lastOrNull?.text ??
                          //'cannot generate data!',
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                                fontSize: 16.0), // Paragraph text
                            h1: const TextStyle(fontSize: 20.0), // Heading 1
                            h2: const TextStyle(fontSize: 18.0), // Heading 2
                            h3: const TextStyle(
                                fontSize: 17.0), // Heading 3 (optional)
                            // Heading 6 (optional)
                            // ... (add other styles as needed)
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            (content.role == 'user')
                                ? "USERNAME (YOU)"
                                : 'role',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ), //?? 'role'
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust radius as needed
                          // ... other decoration properties
                          color: const Color.fromARGB(31, 187, 187, 187),
                        ),
                        child: Markdown(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          data: data.data ?? 'Generation Failed',
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                                fontSize: 16.0), // Paragraph text
                            h1: const TextStyle(fontSize: 20.0), // Heading 1
                            h2: const TextStyle(fontSize: 18.0), // Heading 2
                            h3: const TextStyle(
                                fontSize: 17.0), // Heading 3 (optional)
                            // Heading 6 (optional)
                            // ... (add other styles as needed)
                          ),
                        ),
                      ),
                      //TODO: Markdown Solution
                    ],
                  ),
                ),
        );
      },
    );
  }
}
                    //TODO: Markdown Solution
