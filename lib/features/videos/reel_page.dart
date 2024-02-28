import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoStreamingPage extends StatefulWidget {
  final Uri videoUrl;

  const VideoStreamingPage({super.key, required this.videoUrl});

  @override
  _VideoStreamingPageState createState() => _VideoStreamingPageState();
}

class _VideoStreamingPageState extends State<VideoStreamingPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Main Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             // Assuming 'videos' is your Firebase collection containing video URLs
//             QuerySnapshot<Map<String, dynamic>> snapshot =
//                 await FirebaseFirestore.instance.collection('videos').get();

//             if (snapshot.docs.isNotEmpty) {
//               String videoUrl = snapshot.docs.first['url'];
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => VideoStreamingPage(videoUrl: videoUrl),
//                 ),
//               );
//             } else {
//               // Handle case when there are no videos in the database
//               print('No videos found.');
//             }
//           },
//           child: Text('Open Video Page'),
//         ),
//       ),
//     );
//   }
// }
