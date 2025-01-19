import 'package:flutter/material.dart';
import 'package:spacchiofy/logic/data/track.dart';
import 'package:spacchiofy/logic/player/player.dart';
import 'package:sutils/ui/widgets/resource_image.dart';
import 'package:sutils/utils.dart';

class PlayerBar extends StatefulWidget {
    const PlayerBar({super.key});

    @override
    State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> with StreamListener {

    Playlist? _playlist;
    late int _index;

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        super.updateSubscriptions([
            StronzAudioPlayer.instance.stream.playlistIndex.listen((playlistIndex) =>
                super.setState(() => this._index = playlistIndex)
            ),
            StronzAudioPlayer.instance.stream.playlist.listen((playlist) =>
                super.setState(() {
                    this._playlist = playlist!;
                    this._index = StronzAudioPlayer.instance.playlistIndex;
                })
            ),
        ]);
    }

    @override
    void dispose() {
        super.disposeSubscriptions();
        super.dispose();
    }

    Widget _buildPreview(BuildContext context) {
        Track track = this._playlist![this._index];

        return Row(
            children: [
                ResourceImage(
                    uri: track.thumbnail,
                    width: 100,
                ),
                SizedBox.square(dimension: 10),
                Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Text(track.title,
                                style: TextStyle(
                                    fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis
                            ),
                            Text(track.author,
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                ),
                                overflow: TextOverflow.ellipsis
                            )
                        ]
                    )
                )
            ]
        );
    }

    Widget _buildControls(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.skip_previous_rounded),
                    onPressed: () => StronzAudioPlayer.instance.prev(),
                ),
                IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.pause_rounded),
                    onPressed: () => StronzAudioPlayer.instance.pause(),
                ),
                IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.skip_next_rounded),
                    onPressed: () => StronzAudioPlayer.instance.next(),
                ),
            ],
        );
    }

    Widget _buildOptions(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () => StronzAudioPlayer.instance.unload(),
                )
            ],
        );
    }

    @override
    Widget build(BuildContext context) {
        if(this._playlist == null)
            return SizedBox.shrink();

        return Container(
            padding: EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.surface,
            child: IntrinsicHeight(
                child: Row(
                    children: [
                        Flexible(
                            child: this._buildPreview(context),
                        ),
                        Flexible(
                            child: this._buildControls(context),
                        ),
                        Flexible(
                            child: this._buildOptions(context),
                        )
                    ]
                )
            )
        );
    }
}
