import 'dart:async';

import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:animate_do/animate_do.dart';

import 'package:provider/provider.dart';

import 'package:flutter_music_player/src/helpers/helpers.dart';
import 'package:flutter_music_player/src/models/audio_player_model.dart';
import 'package:flutter_music_player/src/widgets/custom_appbar.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          //Gradient Background
          _Background(),

          Column(
            children: <Widget>[

              CustomAppBar(),

              _ImageDiscDuration(),

              _PlayTitle(),

              Expanded(
                child: _Lyrics()
              )


            ],
          ),


        ]
      )
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
             Color(0xff1E1C24),
             Color(0xff484750)
           
          ]
        )
      ),
    );
  }
}

class _Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: ListWheelScrollView(
        itemExtent: 42, 
        diameterRatio: 1.5,
        physics: BouncingScrollPhysics(),
        children: lyrics.map((line) {
          return Text(line, 
            style: TextStyle(
              fontSize: 18, 
              color: Colors.black87.withOpacity(1.0)
            )
          );
        }).toList()
      ),
    );
  }
}

class _PlayTitle extends StatefulWidget {
  @override
  __PlayTitleState createState() => __PlayTitleState();
}

class __PlayTitleState extends State<_PlayTitle> with SingleTickerProviderStateMixin{
  AnimationController controller;
  bool isPlaying = false;
  bool firstTime = true;

  final assetsAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500) );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

    assetsAudioPlayer.open(Audio("assets/bigger.mp3"));

    assetsAudioPlayer.currentPosition.listen((Duration duration) {
      audioPlayerModel.current = duration;
    });

    assetsAudioPlayer.current.listen( (Playing playingAudio) {
      audioPlayerModel.songDuration = playingAudio.audio.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(top: 25),
      child: Row(
        children: <Widget>[

          Column(
            children: <Widget>[

              //Song title
              Text('Bigger Jesus', style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8))),

              //Artist
              Text('-Jekalyn Carr-', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.4)))

            ],
          ),

          Spacer(),

          //Play button
          FloatingActionButton(
            onPressed: (){
              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

              if (this.isPlaying) {
                controller.reverse();
                this.isPlaying = false;

                Timer(Duration(milliseconds: 300), () {
                  audioPlayerModel.controller.stop();
                });
              } else {
                controller.forward();
                audioPlayerModel.controller.repeat();
                this.isPlaying = true;
              }

              if (this.firstTime) {
                this.firstTime = false;
                this.open();
              } else {
                assetsAudioPlayer.playOrPause();
              }

            },
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: controller),
            elevation: 0,
            highlightElevation: 0,
          )

        ],
      ),
    );
  }
}

class _ImageDiscDuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: <Widget>[

          _ImageDisc(),
          
          Spacer(),

          _DurationBar(),
          

        ],
      ),
    );
  }
}

class _DurationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle( color: Colors.white.withOpacity(0.4) );
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final percentage = audioPlayerModel.percentage;

    return Container(
      child: Column(
        children: <Widget>[

          Text('${audioPlayerModel.songTotalDuration}', style: textStyle),
          SizedBox(height: 10),

          Stack(
            children: <Widget>[

              Container(
                width: 3,
                height: 200,
                color: Colors.white.withOpacity(0.1),
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 200 * percentage,
                  color: Colors.white.withOpacity(0.8),
                ),
              )

            ],
          ),

          SizedBox(height: 10),
          Text('${audioPlayerModel.currentSecond}', style: textStyle),

        ],
      ),
    );
  }
}

class _ImageDisc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: EdgeInsets.all(20),
      width: 220,
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(220),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[

            //Image disc
            SpinPerfect(
              duration: Duration(seconds: 10),
              infinite: true,
              animate: false,
              manualTrigger: true,
              controller: (animationController) => audioPlayerModel.controller = animationController,
              child: Image(image: AssetImage('assets/Jekalyn-Carr.jpg'))
            ),

            //center circles
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(25)
              ),
            ),

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Color(0xff1C1C25),
                borderRadius: BorderRadius.circular(18)
              ),
            ),
          ],
        ),
      ),
      //Border
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(220),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24)
          ]
        )
      ),
    );
  }
}