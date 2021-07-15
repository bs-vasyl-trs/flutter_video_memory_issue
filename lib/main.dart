import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

double calculateScalingForAspectRatio(
  double videoFrameAspectRatio,
  double screenAspectRatio,
) {
  return max(videoFrameAspectRatio, screenAspectRatio) /
      min(videoFrameAspectRatio, screenAspectRatio);
}

class VideoSourceInfo {
  final String? videoUrl;
  final double? aspectRatio;

  const VideoSourceInfo({
    this.videoUrl,
    this.aspectRatio,
  });
}

class Player extends StatefulWidget {
  final VideoSourceInfo info;
  Player({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController? _controller;
  VideoSourceInfo get info => widget.info;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      widget.info.videoUrl!,
    )
      ..initialize().then((value) => setState(() {})).catchError((e) {
        print(e);
      })
      ..play();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoScale = calculateScalingForAspectRatio(
      info.aspectRatio!,
      MediaQuery.of(context).size.aspectRatio,
    );
    return _controller != null
        ? Transform.scale(
            scale: videoScale,
            child: VideoPlayer(_controller!),
          )
        : Container();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isVisible = false;
  static final videoInfo = const VideoSourceInfo(
    videoUrl:
        'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    aspectRatio: 0.5625,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isVisible
            ? Player(
                info: videoInfo,
                key: ValueKey('player'),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
        tooltip: _isVisible ? 'Add' : 'Remove',
        child: Icon(
          _isVisible ? Icons.remove : Icons.add,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
