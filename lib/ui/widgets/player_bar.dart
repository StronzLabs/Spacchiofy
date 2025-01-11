import 'package:flutter/material.dart';
import 'package:spacchiofy/logic/player/player.dart';
import 'package:spacchiofy/ui/widgets/player_bar_context.dart';

class PlayerBar extends StatefulWidget {
    const PlayerBar({super.key});

    @override
    State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {

    Future<void> _onClose() async {
        await StronzAudioPlayer.stop();
        if(super.mounted)
            PlayerBarContext.of(context).closePlayerBar();
    }

    @override
    Widget build(BuildContext context) {
        return Card(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                    children: [
                        Text("A"),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: this._onClose,
                        )
                    ]
                )
            ),
        );
    }

}