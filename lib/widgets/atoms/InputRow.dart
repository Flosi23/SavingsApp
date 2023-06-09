import 'package:flutter/cupertino.dart';

class InputRow extends StatelessWidget {
  const InputRow({super.key, required this.child, this.icon});

  final Widget? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Center(child: icon),
        ),
        Expanded(child: child)
      ],
    );
  }
}
