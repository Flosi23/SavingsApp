import 'package:flutter/material.dart';
import 'package:savings_app/widgets/atoms/CashFlowCategoryIcon.dart';

import '../../models/category.dart';

class SelectCategoryResult {
  const SelectCategoryResult({this.category, required this.categoryType});

  final CashFlowCategory? category;
  final CashFlowCategoryType categoryType;
}

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key, required this.categories});

  final List<CashFlowCategory> categories;

  @override
  State<StatefulWidget> createState() => _SelectCategoryState();
}

enum CashFlowCategoryType { income, expense, transfer }

class _SelectCategoryState extends State<SelectCategory> {
  CashFlowCategoryType _selectedCategoryType = CashFlowCategoryType.expense;
  CashFlowCategory? _selectedCategory;
  List<CashFlowCategory> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    changeSelectedCategories();
  }

  void changeCategoryType(Set<CashFlowCategoryType> newSelection) {
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
      _selectedCategories = widget.categories.where((category) {
        if (_selectedCategoryType == CashFlowCategoryType.expense) {
          return !category.isIncomeCategory;
        }

        if (_selectedCategoryType == CashFlowCategoryType.income) {
          return category.isIncomeCategory;
        }

        return false;
      }).toList();
    });
  }

  void close() {
    SelectCategoryResult result = SelectCategoryResult(
        category: _selectedCategory, categoryType: _selectedCategoryType);

    Navigator.pop(context, result);
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
                        value: CashFlowCategoryType.expense,
                        label: Text("Expense")),
                    ButtonSegment(
                        value: CashFlowCategoryType.income,
                        label: Text("Income")),
                  ],
                  selected: {_selectedCategoryType},
                  onSelectionChanged: changeCategoryType,
                ),
                SegmentedButton(
                  segments: const [
                    ButtonSegment(
                        value: CashFlowCategoryType.transfer,
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
