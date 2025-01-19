class Track {
    final String title;
    final Uri thumbnail;
    final String id;
    final Duration length;
    final String author;

    const Track(this.title, this.thumbnail, this.length, this.author, this.id);
}

class Playlist {
    final String name;
    final List<Track> tracks;
    final Uri cover;

    int get length => this.tracks.length;

    const Playlist(this.name, this.tracks, this.cover);

    Track operator [](int index) => this.tracks[index];

    Playlist copyWith({String? name, List<Track>? tracks, Uri? cover}) {
        return Playlist(
            name ?? this.name,
            tracks ?? this.tracks,
            cover ?? this.cover
        );
    }
}
