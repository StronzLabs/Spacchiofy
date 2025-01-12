import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spacchiofy/ui/pages/home_page.dart';
import 'package:spacchiofy/ui/pages/loading_page.dart';
import 'package:spacchiofy/ui/widgets/player_bar_context.dart';

class Spacchiofy extends StatelessWidget {
    static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    const Spacchiofy({super.key});

    static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: (Colors.grey[900])!,
        colorScheme: ColorScheme.dark(
            brightness: Brightness.dark,
            primary: Colors.orange,
            secondary: Colors.grey,
            surface: Color(0xff121212),
            surfaceTint: Colors.transparent,
            surfaceContainerHigh: (Colors.grey[900])!,
            error: Colors.red,
            secondaryContainer: Colors.orange
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
            linearTrackColor: Colors.grey
        ),
        appBarTheme: AppBarTheme(
            centerTitle: true
        ),
        snackBarTheme: SnackBarThemeData(
            backgroundColor: Color(0xff121212),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            contentTextStyle: TextStyle(
                color: Colors.white
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
            )
        ),
        expansionTileTheme: ExpansionTileThemeData(
            shape: Border()
        ),
        cardTheme: CardTheme(
            clipBehavior: Clip.antiAlias,
        )
    );

    @override
    Widget build(BuildContext context) {
        return Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
                LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
            },
            child: MaterialApp(
                themeMode: ThemeMode.dark,
                title: 'Spacchiofy',
                theme: Spacchiofy.theme,
                initialRoute: '/loading',
                routes: {
                    '/loading': (context) => LoadingPage(),
                    '/home' : (context) => HomePage(),
                },
                navigatorKey: Spacchiofy.navigatorKey,
                debugShowCheckedModeBanner: false,
                builder: (context, child) => PlayerBarContext(child: child),
            )
        );
    }
}
