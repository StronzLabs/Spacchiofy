import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:spacchiofy/logic/data/track.dart';
import 'package:spacchiofy/logic/storage/settings.dart';
import 'package:spacchiofy/ui/widgets/track_card.dart';

class SearchPage extends SearchDelegate {

    String _lastQuery = "";
    AsyncMemoizer<List<Track>> _memorizer = AsyncMemoizer<List<Track>>();

    // fluterr doesn't propagate the theme to the search bar automatically
    @override
    ThemeData appBarTheme(BuildContext context) {
        return Theme.of(context);
    }

    @override
    String get searchFieldLabel => "Cerca su Spacchiofy";

    @override
    List<Widget> buildActions(BuildContext context) {
        return [
            Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => super.query = ""
                )
            )
        ];
    }

    @override
    Widget buildLeading(BuildContext context) {
        return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => super.close(context, null)
        );
    }

    Widget _buildNoResults(BuildContext context) {
        return const Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Icon(Icons.search_off, size: 100),
                    SizedBox(height: 10),
                    Text("Nessun risultato")
                ]
            )
        );
    }

    @override
    Widget buildResults(BuildContext context) {
        if(super.query != this._lastQuery) {
            this._lastQuery = super.query;
            this._memorizer = AsyncMemoizer<List<Track>>();
        }
        
        return FutureBuilder(
            future: this._memorizer.runOnce(() => Settings.site.search(super.query)),
            builder: (context, snapshot) {
                if(snapshot.connectionState != ConnectionState.done)
                    return const Center(child: CircularProgressIndicator());

                List<Track> tracks = snapshot.data as List<Track>;

                if(tracks.isEmpty)
                    return this._buildNoResults(context);

                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ListView(
                        children: [
                            for(Track track in tracks)
                                TrackCard(track: track)
                        ],
                    ),
                );
            }
        );
    }

    @override
    Widget buildSuggestions(BuildContext context) => this.buildResults(context);
}
