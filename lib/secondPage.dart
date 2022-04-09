import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class secondPage extends StatefulWidget {
  const secondPage({Key? key}) : super(key: key);

  @override
  State<secondPage> createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
  int maxduration = 100;
  int currentpos = 0;
  String textHolder = "Speed: Normal";
  double speed = 1;
  String currentpostlabel = "00:00";
  String maxdurationlabel = "00:00";
  String audioasset = "assets/audio/audioToba.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  late Uint8List audiobytes;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ByteData bytes = await rootBundle.load(audioasset);
      audiobytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

      player.onDurationChanged.listen((Duration d) {
        maxduration = d.inMilliseconds;

        int mhours = Duration(milliseconds: maxduration).inHours;
        int mminutes = Duration(milliseconds: maxduration).inMinutes;
        int mseconds = Duration(milliseconds: maxduration).inSeconds;

        int hhours = mhours;
        int hminutes = mminutes - (mhours * 60);
        int hseconds = mseconds - (mminutes * 60 + mhours * 60 * 60);

        maxdurationlabel = "$hhours:$hminutes:$hseconds";

        setState(() {});
      });

      player.onAudioPositionChanged.listen((Duration p) {
        currentpos = p.inMilliseconds;

        int shours = Duration(milliseconds: currentpos).inHours;
        int sminutes = Duration(milliseconds: currentpos).inMinutes;
        int sseconds = Duration(milliseconds: currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rhours:$rminutes:$rseconds";

        setState(() {});
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.6,
              ),
              Text(
                "$textHolder",
                style: TextStyle(color: Colors.white),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  child: Text(
                    currentpostlabel,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                Container(
                  child: Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    value: double.parse(currentpos.toString()),
                    min: 0,
                    max: double.parse(maxduration.toString()),
                    divisions: maxduration,
                    label: currentpostlabel,
                    onChanged: (double value) async {
                      int seekval = value.round();
                      int result =
                          await player.seek(Duration(milliseconds: seekval));
                      if (result == 1) {
                        currentpos = seekval;
                      } else {
                        print("Seek Unsuccessful.");
                      }
                    },
                  ),
                ),
                Container(
                  child: Text(
                    maxdurationlabel,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ]),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                  child: Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: CircleBorder(),
                          fixedSize: Size(80, 70)),
                      onPressed: () {
                        if (speed > 1 && speed <= 2) {
                          player.setPlaybackRate(1.0);
                          speed = speed / 2;
                          setState(() {
                            textHolder = "Speed: Normal";
                          });
                        } else if (speed > 2 && speed <= 4) {
                          player.setPlaybackRate(1.5);
                          speed = speed / 2;
                          setState(() {
                            textHolder = "Speed: $speed" + "X";
                          });
                        } else if (speed == 1) {
                          player.setPlaybackRate(0.5);
                          speed = 1 / 2;
                          setState(() {
                            textHolder = "Speed: 0.5X";
                          });
                        } else if (speed <= 0.5) {
                          print("Minimum Speed");
                          setState(() {
                            textHolder = "Speed: 0.5X";
                          });
                        }
                      },
                      child: Icon(
                        Icons.fast_rewind,
                        size: 48,
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(70, 70)),
                      onPressed: () async {
                        if (!isplaying && !audioplayed) {
                          int result = await player.playBytes(audiobytes);
                          if (result == 1) {
                            //play success
                            setState(() {
                              isplaying = true;
                              audioplayed = true;
                            });
                          } else {
                            print("Error while playing audio.");
                          }
                        } else if (audioplayed && !isplaying) {
                          int result = await player.resume();
                          if (result == 1) {
                            //resume success
                            setState(() {
                              isplaying = true;
                              audioplayed = true;
                            });
                          } else {
                            print("Error on resume audio.");
                          }
                        } else {
                          int result = await player.pause();
                          if (result == 1) {
                            //pause success
                            setState(() {
                              isplaying = false;
                            });
                          } else {
                            print("Error on pause audio.");
                          }
                        }
                      },
                      child: Icon(
                        isplaying ? Icons.pause : Icons.play_arrow,
                        size: 38,
                        color: Color(0xff499595),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: CircleBorder(),
                          fixedSize: Size(80, 70)),
                      onPressed: () {
                        if (speed < 2 && speed > 0.5) {
                          player.setPlaybackRate(1.5);
                          speed = speed * 2;
                          setState(() {
                            textHolder = "Speed: $speed" + "X";
                          });
                        } else if (speed < 4 && speed >= 2) {
                          player.setPlaybackRate(2.0);
                          speed = speed * 2;
                          setState(() {
                            textHolder = "Speed: $speed" + "X";
                          });
                        } else if (speed == 0.5) {
                          player.setPlaybackRate(1.0);
                          speed = speed * 2;
                          setState(() {
                            textHolder = "Speed: Normal";
                          });
                        } else if (speed >= 4) {
                          print("Maximum Speed");
                        }
                      },
                      child: Icon(
                        Icons.fast_forward,
                        size: 46,
                      )),
                ],
              )),
              // Container(
              //   child: Wrap(
              //     spacing: 10,
              //     children: [
              //       ElevatedButton.icon(
              //           onPressed: () async {
              //             if (!isplaying && !audioplayed) {
              //               int result = await player.playBytes(audiobytes);
              //               if (result == 1) {
              //                 //play success
              //                 setState(() {
              //                   isplaying = true;
              //                   audioplayed = true;
              //                 });
              //               } else {
              //                 print("Error while playing audio.");
              //               }
              //             } else if (audioplayed && !isplaying) {
              //               int result = await player.resume();
              //               if (result == 1) {
              //                 //resume success
              //                 setState(() {
              //                   isplaying = true;
              //                   audioplayed = true;
              //                 });
              //               } else {
              //                 print("Error on resume audio.");
              //               }
              //             } else {
              //               int result = await player.pause();
              //               if (result == 1) {
              //                 //pause success
              //                 setState(() {
              //                   isplaying = false;
              //                 });
              //               } else {
              //                 print("Error on pause audio.");
              //               }
              //             }
              //           },
              //           icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
              //           label: Text(isplaying ? "Pause" : "Play")),
              //       ElevatedButton.icon(
              //           onPressed: () async {
              //             int result = await player.stop();
              //             if (result == 1) {
              //               //stop success
              //               setState(() {
              //                 isplaying = false;
              //                 audioplayed = false;
              //                 currentpos = 0;
              //               });
              //             } else {
              //               print("Error on stop audio.");
              //             }
              //           },
              //           icon: Icon(Icons.stop),
              //           label: Text("Stop")),
              //     ],
              //   ),
              // )
              // Slider(value: value, onChanged: onChanged),
            ],
          ),
        )
      ]),
    );
  }
}
