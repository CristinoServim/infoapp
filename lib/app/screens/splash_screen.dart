import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/LoadInfobrasil.mp4')
          ..initialize().then((context) {
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            setState(() {});
          });
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _videoPlayerController.value.size.height,
                width: _videoPlayerController.value.size.width,
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//   return Consumer<AuthProvider>(
    //     builder: (context, authProvider, child) {
    //       return Scaffold(
    //         body: Center(
    //           child: Container(
    //             width: 200,
    //             height: 200,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               border: Border.all(
    //                 color: Theme.of(context).colorScheme.primary,
    //                 width: 3.0,
    //               ),
    //             ),
    //             child: ClipOval(
    //               child: Image.asset(
    //                 'assets/images/logop.png',
    //                 width: 100,
    //                 height: 100,
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
