import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spacchiofy/logic/bindings/site.dart';
import 'package:spacchiofy/logic/storage/settings.dart';
import 'package:sutils/logic/loading/stronz_dynamic_loading_phase.dart';
import 'package:sutils/ui/pages/stronz_loading_page.dart';
import 'package:sutils/ui/pages/stronz_static_loading_phase.dart';

class LoadingPage extends StatelessWidget {
    const LoadingPage({super.key});

    @override
    Widget build(BuildContext context) {
        return StronzLoadingPage(
            splash: SvgPicture.asset("assets/logo.svg",
                width: 200,
                height: 200,
            ),
            onOffline: () async {
                await Settings.instance.unserialize();
                Settings.online = false;
                await Settings.instance.serialize();
            },
            phases: [
                StronzStaticLoadingPhase(
                    weight: 0.5,
                    steps: [
                        Settings.instance.unserialize(),
                    ]
                ),
                StronzDynamicLoadingPhase(
                    weight: 0.25,
                    steps: [
                        YTMusic.instance.progress,
                    ]
                ),
                StronzStaticLoadingPhase(
                    weight: 0.25,
                    steps: [
                        YTMusic.instance.initialized,
                    ]
                )
            ],
        );
    }
}
