import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/screens/settings_screen.dart';
import 'package:savings_app/screens/timeline_screen.dart';
import 'package:savings_app/screens/wallet_overview_screen.dart';

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
  int _selectedIndex = 0;

  final List<Page> _pages = [
    Page("Wallets", Icons.wallet, const WalletOverviewScreen()),
    Page("Timeline", Icons.timeline, const TimelineScreen()),
    Page("Settings", Icons.settings, const SettingsScreen())
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex).screen,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _pages.map((page) =>
            NavigationDestination(label: page.name, icon: Icon(page.iconData))
        ).toList()
      ),
    );
  }
}
