import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {
  
  Duration _songDuration = new Duration(milliseconds: 0);
  Duration _current = new Duration(milliseconds: 0);
  AnimationController _controller;
  bool _playing = false;

  //getters
  AnimationController get controller => this._controller;
  Duration get songDuration => this._songDuration;
  Duration get current => this._current;
  bool get playing => this._playing;

  String get songTotalDuration => this.printDuration(this._songDuration);
  String get currentSecond     => this.printDuration(this._current);

  double get percentage => (this.songDuration.inSeconds > 0) 
                            ? this._current.inSeconds / this._songDuration.inSeconds
                            : 0;

  //setters
  set songDuration(Duration songDuration) {
    this._songDuration = songDuration;
    notifyListeners();
  }

  set current(Duration current) {
    this._current = current;
    notifyListeners();
  }

  set controller(AnimationController controller) {
    this._controller = controller;
  }

  set playing(bool playing) {
    this._playing = playing;
    notifyListeners();
  }

  //methods
  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }

}