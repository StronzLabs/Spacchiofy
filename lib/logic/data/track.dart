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

    const Playlist(this.name, this.tracks, this.cover);
}
