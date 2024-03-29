import 'package:flutter/material.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/widgets/atoms/CashFlowCategoryIcon.dart';

import '../../models/category.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key, required this.categories});

  final List<CashFlowCategory> categories;

  @override
  State<StatefulWidget> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  CashTransactionType _selectedCategoryType = CashTransactionType.expense;
  CashFlowCategory? _selectedCategory;
  List<CashFlowCategory> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    changeSelectedCategories();
  }

  void changeCategoryType(Set<CashTransactionType> newSelection) {
    setState(() {
      _selectedCategoryType = newSelection.first;
    });
    changeSelectedCategories();
  }

  void changeCategory(CashFlowCategory newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
    close();
  }

  void changeSelectedCategories() {
    setState(() {
      _selectedCategories = widget.categories
          .where((category) => category.type == _selectedCategoryType)
          .toList();
    });
  }

  void close() {
    Navigator.pop(context, _selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SegmentedButton(
                  segments: const [
                    ButtonSegment(
                        value: CashTransactionType.expense,
                        label: Text("Expense")),
                    ButtonSegment(
                        value: CashTransactionType.income,
                        label: Text("Income")),
                  ],
                  selected: {_selectedCategoryType},
                  onSelectionChanged: changeCategoryType,
                ),
                SegmentedButton(
                  segments: const [
                    ButtonSegment(
                        value: CashTransactionType.transfer,
                        label: Text("Transfer")),
                  ],
                  selected: {_selectedCategoryType},
                  onSelectionChanged: changeCategoryType,
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
                child: GridView.count(
              physics: const ScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              crossAxisCount: 4,
              children: _selectedCategories
                  .map((category) => InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Column(children: [
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: CashFlowCategoryIcon(category: category)),
                          const SizedBox(height: 5),
                          Text(category.name, overflow: TextOverflow.ellipsis)
                        ]),
                        onTap: () => {changeCategory(category)},
                      ))
                  .toList(),
            ))
          ],
        ));
  }
}
