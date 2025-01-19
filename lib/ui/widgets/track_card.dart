import 'package:flutter/material.dart';
import 'package:spacchiofy/logic/data/track.dart';
import 'package:spacchiofy/logic/player/player.dart';
import 'package:sutils/utils.dart';
import 'package:sutils/ui/widgets/resource_image.dart';

class TrackCard extends StatefulWidget {
    final Track track;

    const TrackCard({
        required this.track,
        super.key
    });

    @override
    State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
    bool _hoveringThumbnail = false;

    Widget _buildThumbnail(BuildContext context) {
        return MouseRegion(
            onEnter: (_) => super.setState(() => this._hoveringThumbnail = true),
            onExit: (_) => super.setState(() => this._hoveringThumbnail = false),
            child: Stack(
                alignment: Alignment.center,
                children: [
                    Stack(
                        children: [
                            Hero(
                                tag: super.widget.track,
                                child: ResourceImage(
                                    uri: super.widget.track.thumbnail,
                                ),
                            ),
                            if(this._hoveringThumbnail)
                                Positioned.fill(
                                    child: Container(
                                        color: Colors.black.withAlpha(123),
                                    ),
                                ),
                        ],
                    ),
                    if(this._hoveringThumbnail)
                        IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: this._playTrack,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                        ),
                ]
            )
        );
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onSecondaryTapUp: (details) => this._openMenu(context, details.globalPosition),
            child: ListTile(
                contentPadding: EdgeInsets.only(left: 10, right: 20),
                leading: this._buildThumbnail(context),
                title: Text(super.widget.track.title,
                    style: TextStyle(
                        fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Text(super.widget.track.length.format(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).disabledColor
                            ),
                        ),
                        SizedBox(width: 10),
                        Builder(
                            builder: (context) => IconButton(
                                icon: Icon(Icons.more_horiz),
                                color: Theme.of(context).disabledColor,
                                onPressed: () {
                                    RenderBox button = context.findRenderObject()! as RenderBox;
                                    this._openMenu(context, button.localToGlobal(Offset.zero) + Offset(0, button.size.height));
                                },
                            ),
                        ),
                    ],
                ),
                subtitle: Text(super.widget.track.author,
                    style: TextStyle(
                        color: Theme.of(context).disabledColor
                    ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                ),
                onTap: this._openTrack,
            )
        );
    }

    void _openTrack() {
        Navigator.of(context).pushNamed("/track", arguments: super.widget.track);
    }

    void _playTrack() {
        StronzAudioPlayer.instance.load(Playlist("", [super.widget.track], Uri.parse("")));
    }

    void _openMenu(BuildContext context, Offset offset) async {
        RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
        RelativeRect position = RelativeRect.fromRect(
            offset & Size(40, 40),
            Offset.zero & overlay.size
        );

        String? choice = await showMenu(
            context: context,
            position: position,
            items: [
                PopupMenuItem(
                    value: "queue",
                    child: Text("Aggiungi alla coda"),
                ),
            ]
        );

        switch(choice) {
            case "queue":
                StronzAudioPlayer.instance.enqueue(super.widget.track);
                break;
        }
    }
}
