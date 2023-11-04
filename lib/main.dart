import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/screens/settings_screen.dart';
import 'package:savings_app/screens/timeline_screen.dart';
import 'package:savings_app/screens/wallets_screen.dart';
import 'package:savings_app/widgets/atoms/Provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const Layout(),
      );
    });
  }
}

class Page {
  String name;
  IconData iconData;
  Widget screen;

  Page(this.name, this.iconData, this.screen);
}

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 1;

  late Image _bg1;
  late Image _bg2;
  late Image _bg3;
  late Image _bg4;
  late Image _bg5;
  late WalletsScreen walletsScreen;
  late List<Page> _pages;

  @override
  void initState() {
    super.initState();
    _bg1 = Image.asset("assets/images/bg1.png");
    _bg2 = Image.asset("assets/images/bg2.png");
    _bg3 = Image.asset("assets/images/bg3.png");
    _bg4 = Image.asset("assets/images/bg4.png");
    _bg5 = Image.asset("assets/images/bg5.png");
    _pages = [
      Page(
          "Wallets",
          Icons.wallet,
          WalletsScreen(
            walletBackgroundImages: [_bg1, _bg2, _bg3, _bg4, _bg5],
          )),
      Page("Timeline", Icons.timeline, const TimelineScreen()),
      Page("Settings", Icons.settings, SettingsScreen())
    ];
  }

  @override
  void didChangeDependencies() {
    precacheImage(_bg1.image, context);
    precacheImage(_bg2.image, context);
    precacheImage(_bg3.image, context);
    precacheImage(_bg4.image, context);
    precacheImage(_bg5.image, context);
    super.didChangeDependencies();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AllProvider(
        child: _pages.elementAt(_selectedIndex).screen,
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _pages
              .map((page) => NavigationDestination(
                  label: page.name, icon: Icon(page.iconData)))
              .toList()),
    );
  }
}
