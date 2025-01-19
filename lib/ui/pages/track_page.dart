import 'package:flutter/material.dart';
import 'package:spacchiofy/logic/data/track.dart';
import 'package:sutils/ui/widgets/resource_image.dart';

class TrackPage extends StatelessWidget {
    final Track track;

    const TrackPage({
        required this.track,
        super.key
    });

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Track Page'),
            ),
            body: Row(
                children: [
                    Hero(
                        tag: this.track,
                        child: ResourceImage(
                            uri: this.track.thumbnail,
                        ),
                    ),
                    SizedBox.square(dimension: 10),
                    Flexible(
                        child: FittedBox(
                        child: Text(
                            this.track.title,
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                    ),
                    )
                ],
            ),
        );
    }
}