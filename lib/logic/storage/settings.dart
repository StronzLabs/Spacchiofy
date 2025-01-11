import 'package:spacchiofy/logic/bindings/site.dart';
import 'package:sutils/logic/storage/local_storage.dart';

class Settings extends LocalStorage {
    static final Settings instance = Settings._();
    Settings._() : super("Settings", {
        "site": "YTMusic",
    });

    static Site get site => Site.get(Settings.instance["site"])!;// ?? LocalSite.instance;
    static bool online = false;
}
