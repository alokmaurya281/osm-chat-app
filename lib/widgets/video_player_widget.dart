import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String playerUrl;
  const VideoPlayerWidget({super.key, required this.playerUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? controller;
  bool isPlaying = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.playerUrl));
    controller!.initialize().then((value) {
      setState(() {
        isInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        if (isPlaying) {
          controller!.pause();
          setState(() {
            isPlaying = !isPlaying;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: isInitialized
          ? Stack(
              children: [
                Dialog.fullscreen(
                  child: Center(
                      child: controller!.value.isInitialized
                          ? VideoPlayer(controller!)
                          : VideoPlayer(controller!)),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          controller!.pause();
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          controller!.pause();
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        } else {
                          controller!.play();
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_circle,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }
}
