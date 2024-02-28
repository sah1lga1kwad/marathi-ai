//Pages
import 'package:flutter/material.dart';
import 'package:marathi_ai/features/videos/videowindow.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VideoWindow(),
              VideoWindow(),
              VideoWindow(),
              VideoWindow(),
              VideoWindow(),
              VideoWindow(),
              VideoWindow()
            ],
          ),
        ),
      ),
    );
  }
}
