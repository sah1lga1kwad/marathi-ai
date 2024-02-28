//Firebase Auth
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:marathi_ai/features/translate/translate.dart';
import 'package:marathi_ai/features/videos/videowindow.dart';

//Firebase Cloud
import 'package:cloud_firestore/cloud_firestore.dart';

//Flutter
import 'package:flutter/material.dart';

//Google Gemini
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

//
bool containsEnglishCharacters(String input) {
  // Use a regular expression to match all characters
  String regexString = r'^[a-zA-Z0-9\s\p{L}.<>;}{]\[?|-+]*$';
  RegExp allCharactersRegex = RegExp(regexString);

  // Check if the input string contains only characters (including non-English characters)
  return allCharactersRegex.hasMatch(input);
}

/// ---------------------------------------------------
///
String examplePrompt = "";

class SectionChat extends StatefulWidget {
  const SectionChat({super.key});

  @override
  State<SectionChat> createState() => _SectionChatState();
}

class _SectionChatState extends State<SectionChat> {
  ChatInstanceManager chatInstanceManager = ChatInstanceManager();
  final controller = TextEditingController();
  bool _loading = false;
  int numLines = 0;
  int counter = 0;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  List<Content> chats = [];

  String currentHistoryId = ''; // Store the current HISTORY ID
  String currentHistoryName = ''; // Stores current HISTORY NAME

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        chats.isNotEmpty
            ? const SizedBox(
                height: 20,
              )
            : const SizedBox(
                height: 0,
              ),
        Expanded(
          child: chats.isNotEmpty
              ? Align(
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
                )
              : const SearchIntro(),
        ),
        if (loading) const LinearProgressIndicator(),
        Card(
          margin: const EdgeInsets.all(12),
          color: Colors.black,
          child: Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.1700,
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
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
              if (chats.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 0.0, left: 8),
                  child: IconButton(
                    icon: const Icon(Icons.new_label),
                    color: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          // NEW CHAT BUTTON
                          return AlertDialog(
                            title: const Text('नवीन चॅट सुरू करू इच्छिता?'),
                            content: const Text(
                                'नवीन चॅट सुरू केल्याने आमच्या App ला नवीन संदर्भ मिळेल - जेव्हा तुम्हाला सध्याच्या चॅटव्यतिरिक्त काहीही नवीन शोधायचे असेल तेव्हा नवीन चॅट सुरू करा'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    chatInstanceManager = ChatInstanceManager();
                                    chats = [];
                                    currentHistoryName = '';
                                    currentHistoryId = '';
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('नवीन Chat सुरू!'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 4),
                child: IconButton(
                    hoverColor: Colors.black,
                    onPressed: () async {
                      if (controller.text.isEmpty) {
                        return;
                      }
                      // Variable Declarations
                      final searchedText = controller.text;
                      final inputLangDetect =
                          await detectLanguage(searchedText);
                      String geminiInputTranslated = '';

                      ///
                      ///
                      ///
                      ///
                      if (inputLangDetect == 'mr') {
                        if (containsEnglishCharacters(searchedText)) {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  icon: const Icon(
                                    Icons.add_alert,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                  title: const Text(
                                    'तुम्ही इंग्रजीत मराठी वापरत आहात, कृपया देवनागरीमध्ये मराठी वापरा',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    textAlign: TextAlign.center,
                                    'तुम्ही इंग्रजीत मराठी वापरत आहात, कृपया देवनागरीमध्ये मराठी वापरा',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  actions: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Download मराठी Keyboard',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.white),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]);
                            },
                          );
                          controller.clear();
                          return;
                        } else {
                          geminiInputTranslated = await translateText(
                              searchedText, inputLangDetect, 'en');
                          log(geminiInputTranslated);
                        }
                      } else if (inputLangDetect == 'en') {
                        geminiInputTranslated = searchedText;
                        log('$geminiInputTranslated Detected English No Problem');
                      } else if (inputLangDetect == 'hi') {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                icon: const Icon(
                                  Icons.add_alert,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.black,
                                title: const Text(
                                  'हिंदी भाषा आढळली, कृपया मराठी देवनागरी मधे वापरा',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  textAlign: TextAlign.center,
                                  'उदाहरण: मला भारताचा इतिहास सांगा',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                actions: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Download मराठी Keyboard',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.white),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Ok',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                          },
                        );

                        controller.clear();
                        return;
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                icon: const Icon(
                                  Icons.add_alert,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.black,
                                title: const Text(
                                  'तुम्ही चुकीची भाषा किंवा चुकीचे स्पेलिंग वापरत आहात',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  textAlign: TextAlign.center,
                                  'योग्य उदाहरण: मला भारताचा इतिहास सांगा',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                actions: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Download मराठी Keyboard',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.white),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Ok',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                          },
                        );
                        controller.clear();
                        return;
                      }

                      ///
                      ///
                      ///
                      ///
                      if (controller.text.isNotEmpty) {
                        // If currentHistoryId is empty, generate a new history ID
                        if (currentHistoryId.isEmpty) {
                          currentHistoryId =
                              await generateNewHistoryId(geminiInputTranslated);
                          // Set the document ID as the chat instance ID
                          chatInstanceManager
                              .setChatInstanceId(currentHistoryId);
                        }

                        final gemini = Gemini.instance;

                        chats.add(Content(
                            role: 'user',
                            parts: [Parts(text: geminiInputTranslated)]));
                        controller.clear();
                        loading = true;

                        try {
                          gemini.chat(chats).then((e) async {
                            final geminiOutput = e?.output;
                            log(geminiOutput ?? "Gemini Output is Null");

                            if (geminiOutput == null) {
                              chats.removeLast();
                              loading = false;
                              controller.clear();
                              return;
                            }

                            chats.add(Content(
                                role: 'model',
                                parts: [Parts(text: geminiOutput)]));
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
                                'content': geminiOutput,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            });
                          });
                        } on HttpException catch (e) {
                          log("Http Request Failed! $e");
                        } catch (e) {
                          log('$e THIS IS THE EXCEPTION');
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  icon: const Icon(
                                    Icons.add_alert,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    'App Software Issue: $e',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    textAlign: TextAlign.center,
                                    'App मध्ये काही समस्या आहेत',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  actions: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.white),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]);
                            },
                          );
                          controller.clear();
                          return;
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }

// TODO: When Bard is asked anything in Marathi; Where it trys to respond in Marathi It Messes Up

// TODO: When English Is Inputed, Responses Should Be In English Fix That. In Future
  // Function to generate a new history ID
  Future<String> generateNewHistoryId(String historyName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final history = await FirebaseFirestore.instance
          .collection('/users')
          .doc(currentUser.uid)
          .collection('history')
          .add({
        'history_name': historyName,
        'timestamp': FieldValue.serverTimestamp()
      });
      return history.id;
    } else {
      throw Exception('User not authenticated.');
    }
  }

// TODO: Chats[] Should eng or marathi response type; If they ask also in marathi how will they fix it? Ask Palash;
// TODO: Focus on Marathi ONLY Dont do anyhting else.
// Try & Catch Block

  Future<String> translated(Content content, int index) async {
    final Content content = chats[index];

    Future<String> translatedUserText;
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
                                fontSize: 18.0), // Paragraph text
                            h1: const TextStyle(fontSize: 18.0), // Heading 1
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

//--------------------------------------------------- Search Introduction

class SearchIntro extends StatelessWidget {
  const SearchIntro({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.725,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VideoWindow(),
              DisplayExamplePrompt(exampleDisplayPrompts: 'इतिहास विचारा '),
              DisplayExamplePrompt(
                  exampleDisplayPrompts: 'गृहकार्य मधे मदत पाहीजे '),
              DisplayExamplePrompt(
                  exampleDisplayPrompts: 'यूट्यूब व्हिडिओ स्क्रिप्ट बनवा '),
              DisplayExamplePrompt(
                  exampleDisplayPrompts: 'चिकन बिर्याणी रेसिपी '),
              DisplayExamplePrompt(
                  exampleDisplayPrompts: 'ऑनलाइन पैसे कसे कमवायचे '),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayExamplePrompt extends StatelessWidget {
  const DisplayExamplePrompt({super.key, required this.exampleDisplayPrompts});
  final String exampleDisplayPrompts;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15),
        child: ElevatedButton.icon(
          onPressed: () {},
          label: Text(
            exampleDisplayPrompts,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          icon: const Icon(
            Icons.arrow_circle_right_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////

class ChatInstanceManager {
  String _chatInstanceId = '';

  String get chatInstanceId => _chatInstanceId;

  void setChatInstanceId(String id) {
    _chatInstanceId = id;
  }
}

Future<void> showMyDialog(
    BuildContext context, String title, String subtitle) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('तुम्ही चुकीची भाषा वापरत आहात, कृपया मराठी वापरा'),
        content: const Text('उदाहरण: मला भारताचा इतिहास सांगा'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Wishlist'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
