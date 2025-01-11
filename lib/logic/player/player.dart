import 'package:just_audio/just_audio.dart';
import 'package:spacchiofy/logic/data/track.dart';

final class StronzAudioPlayer {
    StronzAudioPlayer._();

    static final AudioPlayer _player = AudioPlayer();
    static final List<Track> _queue = [];

    static void enqueue(Track track) {
       StronzAudioPlayer._queue.add(track);
    }

    static Future<void> play() async {
        await _player.play();
    }

    static Future<void> pause() async {
        await _player.pause();
    }

    static Future<void> stop() async {
        await _player.stop();
    }
}