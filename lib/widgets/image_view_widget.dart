import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ImageViewWidget extends StatefulWidget {
  final String message;
  const ImageViewWidget({super.key, required this.message});

  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> {
  VideoPlayerController? controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.message,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
              errorWidget: (context, url, child) {
                return const Icon(
                  Icons.image,
                  size: 80,
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 28,
              )),
        ),
      ],
    );
  }
}
