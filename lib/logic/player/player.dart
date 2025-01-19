import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spacchiofy/logic/data/track.dart';

final class ControllerStream {
    final Stream<Playlist?> playlist;
    final Stream<int> playlistIndex;

    const ControllerStream({
        required this.playlist,
        required this.playlistIndex
    });
}

final class StronzAudioPlayer {
    static final StronzAudioPlayer instance = StronzAudioPlayer._();
    StronzAudioPlayer._();

    Playlist? _playlist;
    Playlist? get playlist => this._playlist;
    final StreamController<Playlist?> _playlistStreamController = StreamController<Playlist?>.broadcast();
    @protected
    set playlist(Playlist? playlist) {
        if(this._playlist != playlist)
            this._playlistStreamController.add(this._playlist = playlist);
    }

    int _playlistIndex = 0;
    int get playlistIndex => this._playlistIndex;
    final StreamController<int> _playlistIndexStreamController = StreamController<int>.broadcast();
    @protected
    set playlistIndex(int playlistIndex) {
        if(this._playlistIndex != playlistIndex)
            this._playlistIndexStreamController.add(this._playlistIndex = playlistIndex);
    }

    ControllerStream get stream => ControllerStream(
        playlist: this._playlistStreamController.stream,
        playlistIndex: this._playlistIndexStreamController.stream
    );

    void load(Playlist playlist) {
        this._playlistIndex = 0;
        this.playlist = playlist;
    }

    void unload() => this.playlist = null;

    void enqueue(Track track) {
        this.playlist = this._playlist!.copyWith(
            tracks: [...this._playlist!.tracks, track]
        );
    }

    void prev() {
        this.playlistIndex = (this._playlistIndex - 1) % this._playlist!.length;
    }

    void next() {
        this.playlistIndex = (this._playlistIndex + 1) % this._playlist!.length;
    }

    void pause() {
    }

    // Future<void> play() async {
    //     await _player.play();
    // }

    // Future<void> pause() async {
    //     await _player.pause();
    // }

    // Future<void> stop() async {
    //     await _player.stop();
    // }
}
