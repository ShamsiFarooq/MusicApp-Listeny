import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;

Color color2 = const Color(0xFF2E0249);

Color color1 = const Color(0xFF570A57);

Color color3 = const Color(0xFFA91079);

Color color4 = Color.fromARGB(255, 237, 229, 235);

const height15 = SizedBox(height: 15);
const height30 = SizedBox(height: 30);

const height50 = SizedBox(height: 63);
const width30 = SizedBox(width: 30);
const width15 = SizedBox(width: 10);
const width50 = SizedBox(width: 100);

// Audio Constants

var audio = musicNotifier.value;
ValueNotifier<bool> isPlaying = ValueNotifier(false);

// Playlist Setting

AudioPlayer audioPlayer = AudioPlayer();
ConcatenatingAudioSource createSongList(List<aq.SongModel> songs) {
  List<AudioSource> sources = [];
  for (var song in songs) {
    sources.add(AudioSource.uri(
      Uri.parse(song.uri!),
      tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          album: song.album,
          artist: song.artist,
          artUri: Uri.parse(
              "https://imgs.search.brave.com/FWuCxRUj1_kcCS3ZihwnVhbcD9dKD7qM4zLd0iZmrzU/rs:fit:844:225:1/g:ce/aHR0cHM6Ly90c2U0/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5H/ay1odTMxdVh3Um1N/ZW40LVNsbWtRSGFF/SyZwaWQ9QXBp")),
    ));
  }
  return ConcatenatingAudioSource(children: sources);
}
