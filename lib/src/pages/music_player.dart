import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:play_music/src/helpers/helpers.dart';
import 'package:play_music/src/models/audio_payer_model.dart';
import 'package:play_music/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _Background(),
        Column(
          children: [
            CustomAppBar(),
            _ImagenDiscoDuration(),
            _TituloPlay(),
            Expanded(child: _Lyrics())
          ],
        ),
      ]),
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
            colors: [Color(0xff33333E), Color(0xff201E28)],
          )),
    );
  }
}

class _Lyrics extends StatelessWidget {
  const _Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 1.4,
        children: lyrics
            .map(
              (linea) => Text(
                linea,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TituloPlay extends StatefulWidget {
  const _TituloPlay({
    Key? key,
  }) : super(key: key);

  @override
  State<_TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<_TituloPlay>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController playAnimation;

  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    super.initState();
  }

  @override
  void dispose() {
    this.playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioplayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);

    assetAudioPlayer.open(Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
        autoStart: true, showNotification: true);

    assetAudioPlayer.currentPosition.listen((duration) {
      audioplayerModel.current = duration;
    });
    assetAudioPlayer.current.listen((playindAudio) {
      audioplayerModel.songDuration =
          playindAudio?.audio.duration ?? Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      margin: EdgeInsets.only(top: 40),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Far Away',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 30),
              ),
              Text(
                '-Breaking Benjamin-',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 15),
              ),
            ],
          ),
          Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Color(0xfff8CB51),
            onPressed: () {
              final audioPlayerModel =
                  Provider.of<AudioPlayerModel>(context, listen: false);
              if (this.isPlaying) {
                playAnimation.reverse();
                this.isPlaying = false;
                audioPlayerModel.controller.stop();
              } else {
                playAnimation.forward();
                this.isPlaying = true;
                audioPlayerModel.controller.repeat();
              }
              if (firstTime) {
                this.open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation,
            ),
          )
        ],
      ),
    );
  }
}

class _ImagenDiscoDuration extends StatelessWidget {
  const _ImagenDiscoDuration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 70),
      child: Row(
        children: [
          ImageDisco(),
          SizedBox(
            width: 40,
          ),
          _BarraProgreso()
        ],
      ),
    );
  }
}

class _BarraProgreso extends StatelessWidget {
  const _BarraProgreso({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));
    return Container(
      child: Column(
        children: [
          Text(
            '${audioPlayerModel.songTotalDuration}',
            style: estilo,
          ),
          SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Container(
                width: 3,
                height: 230 * porcentaje,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 100,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${audioPlayerModel.currentSecond}',
            style: estilo,
          )
        ],
      ),
    );
  }
}

class ImageDisco extends StatelessWidget {
  const ImageDisco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (animationController) =>
                  audioPlayerModel.controller = animationController,
              child: Image(
                image: AssetImage('assets/aurora.jpg'),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(100)),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  color: Color(0xff1C1C25),
                  borderRadius: BorderRadius.circular(100)),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [Color(0xff484750), Color(0xff1E1C24)],
          )),
    );
  }
}
