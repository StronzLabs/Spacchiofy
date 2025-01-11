import 'package:flutter/material.dart';
import 'package:spacchiofy/logic/data/track.dart';
import 'package:sutils/utils.dart';
import 'package:sutils/ui/widgets/resource_image.dart';
import 'package:spacchiofy/ui/widgets/player_bar_context.dart';

class TrackCard extends StatelessWidget {
    final Track track;

    const TrackCard({
        required this.track,
        super.key
    });

    Future<void> _onTap(BuildContext context) async {
        // String url = await Settings.site.doTheThing(track);
        // await StronzAudioPlayer.play(url);
        if(context.mounted)
            PlayerBarContext.of(context).showPlayerBar();
    }

    @override
    Widget build(BuildContext context) {
        return ListTile(
            leading: ResourceImage(
                uri: track.thumbnail,
            ),
            title: Text(track.title,
                style: TextStyle(
                    fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(track.length.format(),
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).disabledColor
                ),
            ),
            subtitle: Text(track.author,
                style: TextStyle(
                    color: Theme.of(context).disabledColor
                ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
            ),
            onTap: () => this._onTap(context),
        );
    }
}
