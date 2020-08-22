import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_music_player/src/models/audio_player_model.dart';
import 'package:flutter_music_player/src/models/theme.dart';
import 'package:flutter_music_player/src/pages/music_player_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new AudioPlayerModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: myTheme,
        home: MusicPlayerPage()
      ),
    );
  }
}