import 'package:flutter/material.dart';

import '../../models/category.dart';

class CashFlowCategoryIcon extends StatelessWidget {
  const CashFlowCategoryIcon({super.key, required this.category});

  final CashFlowCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: category.color, shape: BoxShape.circle),
      child: Icon(
        category.iconData,
      ),
    );
  }
}
