import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spacchiofy/logic/data/track.dart';
import 'package:sutils/logic/data/initializable.dart';
import 'package:sutils/utils.dart';

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

class YTMusic extends Site {
    static Site instance = YTMusic._();
    YTMusic._():  super("YTMusic");

    @override
    Future<List<Track>> search(String query) async {
        if(query.trim().isEmpty)
            return [];

        String jsonQuery = '{"context":{"client":{"clientName":"WEB_REMIX","clientVersion":"1.20241218.01.00"}},"query":"${query}"}';
        String body = await HTTP.post("https://music.youtube.com/youtubei/v1/search?prettyPrint=false", stringBody: jsonQuery);
        Map<String, dynamic> json = jsonDecode(body);

        List<dynamic> contents = json["contents"]["tabbedSearchResultsRenderer"]["tabs"][0]["tabRenderer"]["content"]["sectionListRenderer"]["contents"];
        Map<String, dynamic> musicShelfRenderer = contents.firstWhere((element) => element.containsKey("musicShelfRenderer") && element["musicShelfRenderer"]["title"]["runs"][0]["text"] == "Songs");
        String params = musicShelfRenderer["musicShelfRenderer"]["bottomEndpoint"]["searchEndpoint"]["params"];

        jsonQuery = '{"context":{"client":{"clientName":"WEB_REMIX","clientVersion":"1.20241218.01.00"}},"query":"${query}","params":"${params}"}';
        body = await HTTP.post("https://music.youtube.com/youtubei/v1/search?prettyPrint=false", stringBody: jsonQuery);
        json = jsonDecode(body);

        contents = json["contents"]["tabbedSearchResultsRenderer"]["tabs"][0]["tabRenderer"]["content"]["sectionListRenderer"]["contents"];
        musicShelfRenderer = contents.firstWhere((element) => element.containsKey("musicShelfRenderer") && element["musicShelfRenderer"]["title"]["runs"][0]["text"] == "Songs");
    
        contents = musicShelfRenderer["musicShelfRenderer"]["contents"];

        List<Track> tracks = [];
        for (Map<String, dynamic> content in contents) {
            String title = content["musicResponsiveListItemRenderer"]["flexColumns"][0]["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"][0]["text"];
            String thumbnail = content["musicResponsiveListItemRenderer"]["thumbnail"]["musicThumbnailRenderer"]["thumbnail"]["thumbnails"].last["url"];
            String videoId = content["musicResponsiveListItemRenderer"]["playlistItemData"]["videoId"];
            String duration = content["musicResponsiveListItemRenderer"]["flexColumns"][1]["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"].firstWhere((element) => RegExp(r"^[\d:]+$").hasMatch(element["text"]), orElse: () => {"text": "0:00"})["text"];

            // join from the first run of the 1st flex coumnt until the dot character is encountered, not included
            String author = content["musicResponsiveListItemRenderer"]["flexColumns"][1]["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"].takeWhile((element) => element["text"] != " • ").map((e) => e["text"]).join(" ");

            List<String> parts = duration.split(":").reversed.toList();
            int seconds = 0;
            for (int i = 0; i < parts.length; i++)
                seconds += int.parse(parts[i]) * pow(60, i) as int;

            Track track = Track(title, Uri.parse(thumbnail), Duration(seconds: seconds), author, videoId);
            tracks.add(track);
        }

        return tracks;
    }

    Future<String> getPlayrSource() async {
        String iframeApi = await HTTP.get("https://www.youtube.com/iframe_api");
        String playerVersion = RegExp(r"https:\\\/\\\/www\.youtube\.com\\\/s\\\/player\\\/([^\\]+)\\\/www-widgetapi\.vflset\\\/www-widgetapi\.js").firstMatch(iframeApi)!.group(1)!;
        String playerSource = await HTTP.get("https://www.youtube.com/s/player/${playerVersion}/player_ias.vflset/en_US/base.js");

        return playerSource;
    }

    Future<String> getSignatureTimestamp() async {
        String plyerSource = await this.getPlayrSource();

        String timestamp = RegExp(r"signatureTimestamp:(\d+)").firstMatch(plyerSource)!.group(0)!;
        return timestamp.split(":")[1].trim();
    }

    Future<String> sign(String signString) async {
        String plyerSource = await this.getPlayrSource();

        RegExpMatch reverse = RegExp(r"([\w]+):function\(([\w]+)\){\2\.reverse\(\)}").firstMatch(plyerSource)!;
        RegExpMatch splice = RegExp(r"([\w]+):function\(([\w]+),([\w]+)\){\2\.splice\(0,\3\)}").firstMatch(plyerSource)!;
        RegExpMatch swap = RegExp(r"([\w]+):function\(([\w]+),([\w]+)\){var ([\w]+)=\2\[0];\2\[0]=\2\[\3%\2\.length];\2\[\3%\2\.length]=\4}").firstMatch(plyerSource)!;

        int firstOccurrence = min(reverse.start, min(splice.start, swap.start));
        int identifierEnd = firstOccurrence - 2;
        int identifierStart = firstOccurrence - 2;
        while (plyerSource[--identifierStart] != " ") {}

        String groupName = plyerSource.substring(identifierStart, identifierEnd).trim();

        Map<String, Function> functions = {
            "reverse": (List<String> list) => list.reversed.toList(),
            "splice": (List<String> list, int end) => list.sublist(end),
            "swap": (List<String> list, int a) {
                String c = list[0];
                list[0] = list[a % list.length];
                list[a % list.length] = c;
                return list;
            }
        };

        List<String> sign = signString.split("");

        for (RegExpMatch call in RegExp(r";" + groupName + r"\.([\w]+)\(([\w\d]+)(?:,([\w\d]+))\)").allMatches(plyerSource)) {
            String called = call.group(1)!;
            List<String> parameters = [
                call.group(2)!,
                if(call.groupCount == 3) call.group(3)!
            ];

            if(called == reverse.group(1))
                sign = functions["reverse"]!(sign);
            else if(called == splice.group(1))
                sign = functions["splice"]!(sign, int.parse(parameters[1]));
            else if(called == swap.group(1))
                sign = functions["swap"]!(sign, int.parse(parameters[1]));
        }

        return sign.join("");
    }

    Future<String> extractUrl(Map<String, dynamic> format) async {
        List<String> signatureCipher = format["signatureCipher"].split("&");
        String sp = signatureCipher.firstWhere((element) => element.startsWith("sp=")).substring(3);
        String url = signatureCipher.firstWhere((element) => element.startsWith("url=")).substring(4);
        String s = signatureCipher.firstWhere((element) => element.startsWith("s=")).substring(2);
        s = await sign(Uri.decodeComponent(s));

        url = "${Uri.decodeComponent(url)}&${sp}=${Uri.encodeComponent(s)}";
        return url;
    }

    @override
    Future<String> doTheThing(Track track) async {
        String jsonQuery = '{"context":{"client":{"clientName":"IOS","clientVersion":"19.42.1"}},"videoId":"${track.id}"}';
        String body = await HTTP.post("https://music.youtube.com/youtubei/v1/player?prettyPrint=false", stringBody: jsonQuery);
        Map<String, dynamic> json = jsonDecode(body);

        List<dynamic> formats = json["streamingData"]["adaptiveFormats"];
        formats = formats.where((format) => (format["mimeType"] as String).startsWith("audio/")).toList();

        Map<String, dynamic> format = formats.first;
        String url = format["url"];

        return url;
    }
}
