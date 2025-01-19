import 'package:flutter/material.dart';
import 'package:spacchiofy/logic/data/track.dart';
import 'package:sutils/logic/data/initializable.dart';

abstract class Site extends Initializable {
    final String name;

    Site(this.name);

    @override
    String toString() => this.name;

    Future<List<Track>> search(String query);
    Future doTheThing(Track track);

    static final Map<String, Site> _registry = {};
    static List<Site> get sites => _registry.values.toList();
    static Site? get(String name) => _registry[name];

    @override
    @mustCallSuper
    Future<void> construct() async {
        Site._registry[name] = this;
    }
}
