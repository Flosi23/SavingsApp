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
    // image caching
    precacheImage(const AssetImage("./assets/images/bg1.png"), context);
    precacheImage(const AssetImage("./assets/images/bg2.png"), context);
    precacheImage(const AssetImage("./assets/images/bg3.png"), context);
    precacheImage(const AssetImage("./assets/images/bg4.png"), context);
    precacheImage(const AssetImage("./assets/images/bg5.png"), context);
    precacheImage(const AssetImage("./assets/images/notfound.png"), context);

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

  final List<Page> _pages = [
    Page("Wallets", Icons.wallet, const WalletsScreen()),
    Page("Timeline", Icons.timeline, const TimelineScreen()),
    Page("Settings", Icons.settings, SettingsScreen())
  ];

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
