//Firebase Auth
// import 'package:firebase_auth/firebase_auth.dart';

// TODO: Make New Chat Button Make Chat Empty & Start a new chat.

//Flutter

import 'package:flutter/material.dart';
import 'package:marathi_ai/features/drawer/appdrawer.dart';
import 'package:marathi_ai/features/history/history_page.dart';
import 'package:marathi_ai/features/search/searchnewpage.dart';

List<String> titles = <String>[
  'Search',
  'History',
];

class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;

    return DefaultTabController(
      initialIndex: 0,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 4.0,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white, size: 25),
          title: Image.asset(
            'lib/features/authentication/auth_assets/marathi-ai-logo-login-white.png',
          ),
          titleTextStyle: const TextStyle(color: Colors.white),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.mic),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Announcement: Voice Feature'),
                      content: const Text(
                          'लवकरच व्हॉइस कार्यक्षमता सुरू करत आहे - तुम्ही उत्साहित आहात?'),
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
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            indicatorWeight: 6.0,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white), //For Selected tab
            unselectedLabelStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white), //For Un-selected Tabs
            tabs: <Widget>[
              Tab(
                // icon: const Icon(Icons.history),
                text: titles[0],
              ),
              Tab(
                // icon: const Icon(Icons.search_rounded),
                text: titles[1],
              ),
              // Tab(
              //   // icon: const Icon(Icons.video_call),
              //   text: titles[2],
              // ),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          children: [
            // --------------------------------------- Search Page Here
            const SectionChat(),
            // --------------------------------------- History Pgae
            ChatHistoryPage(),
            // --------------------------------------- Video Page
            // const VideosPage(),
          ],
        ),
      ),
    );
  }
}

//  onPressed: () {
// Navigator.push(context, MaterialPageRoute(
//   builder: (context) {
//     return fullPromptPage();


