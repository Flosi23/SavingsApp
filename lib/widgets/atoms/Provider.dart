import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/providers/CategoryProvider.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/providers/WalletProvider.dart';

class AllProvider extends StatelessWidget {
  const AllProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
      ],
      child: child,
    );
  }
}
