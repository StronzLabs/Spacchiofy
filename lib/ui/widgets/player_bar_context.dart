import 'package:flutter/material.dart';
import 'package:spacchiofy/ui/widgets/player_bar.dart';

class PlayerBarContext extends StatelessWidget {
    final Widget? child;

    const PlayerBarContext({
        required this.child,
        super.key
    });

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: this.child,
            bottomNavigationBar: PlayerBar(),
        );
    }
}
