import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class AssetVideo extends StatefulWidget {
  @override
  _AssetVideoState createState() => _AssetVideoState();
}

class _AssetVideoState extends State<AssetVideo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Image.asset('assets/thumbnail.png'),
              _PlayPauseOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: Container(
            color: Colors.black12,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            try {
              if (Platform.isIOS) {
                if (await canLaunch(
                    'youtube://www.youtube.com/watch?v=CIbqgcBbzZI')) {
                  await launch('youtube://www.youtube.com/watch?v=CIbqgcBbzZI');
                } else {
                  if (await canLaunch(
                      'https://www.youtube.com/watch?v=CIbqgcBbzZI')) {
                    await launch('https://www.youtube.com/watch?v=CIbqgcBbzZI');
                  } else {
                    throw 'Could not launch https://www.youtube.com/watch?v=CIbqgcBbzZI';
                  }
                }
              } else {
                const url = 'https://www.youtube.com/watch?v=CIbqgcBbzZI';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }
            } catch (err) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Something went wrong! Try again"),
              ));
            }
          },
        ),
      ],
    );
  }
}
