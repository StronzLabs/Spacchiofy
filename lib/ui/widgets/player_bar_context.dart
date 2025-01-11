import 'package:flutter/material.dart';
import 'package:spacchiofy/ui/widgets/player_bar.dart';

class PlayerBarContext extends StatefulWidget {
    final Widget? child;

    const PlayerBarContext({
        required this.child,
        super.key
    });

    @override
    State<PlayerBarContext> createState() => PlayerBarContextState();

    static PlayerBarContextState of(BuildContext context) {
        return context.findAncestorStateOfType<PlayerBarContextState>()!;
    }
}

class PlayerBarContextState extends State<PlayerBarContext> {

    bool _showPlayerBar = false;

    Widget _buildPlayerBar(BuildContext context) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: PlayerBar(),
            )
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Stack(
                children: [
                    if(super.widget.child != null)
                        super.widget.child!,
                    if(this._showPlayerBar)
                        this._buildPlayerBar(context),
                ],
            ),
        );
    }

    void showPlayerBar() {
        super.setState(() => this._showPlayerBar = true);
    }

    void closePlayerBar() {
        super.setState(() => this._showPlayerBar = false);
    }
}
