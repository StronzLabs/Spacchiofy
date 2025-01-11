import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spacchiofy/ui/pages/search_page.dart';

class HomePage extends StatelessWidget {
    const HomePage({super.key});

    PreferredSizeWidget _buildAppBar(BuildContext context) {
        return AppBar(
            title: const Text("Spacchiofy"),
            leading: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset("assets/logo.svg"),
            ),
            actions: [
                // IconButton(
                //     icon: const Icon(Icons.settings),
                //     onPressed: () => showDialog(
                //         context: context,
                //         builder: (context) => const SettingsDialog()
                //     ).then((_) => this._refetchLatests())
                // ),
                // const SizedBox(width: 8),
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => showSearch(
                        context: context,
                        delegate: SearchPage(),
                        maintainState: true
                    )
                ),
                const SizedBox(width: 8)
            ]
        );        
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: this._buildAppBar(context),
            body: Center(child: Text("Ciao bro"))
        );
    }
}
