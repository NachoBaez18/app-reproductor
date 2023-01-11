import 'package:flutter/material.dart';
import 'package:play_music/src/models/audio_payer_model.dart';
import 'package:play_music/src/pages/music_player.dart';
import 'package:play_music/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new AudioPlayerModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Payer',
        theme: miTema,
        home: MusicPlayerPage(),
      ),
    );
  }
}
