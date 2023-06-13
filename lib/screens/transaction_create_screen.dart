import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/widgets/atoms/CashFlowCategoryIcon.dart';
import 'package:savings_app/widgets/atoms/InputRow.dart';
import 'package:savings_app/widgets/atoms/SelectItem.dart';
import 'package:savings_app/widgets/molecules/SelectCategory.dart';

class TransactionCreateScreen extends StatefulWidget {
  const TransactionCreateScreen(
      {super.key, required this.wallets, required this.categories});

  final List<Wallet> wallets;
  final List<CashFlowCategory> categories;

  @override
  State<StatefulWidget> createState() => _TransactionCreateScreenState();
}

class _TransactionCreateScreenState extends State<TransactionCreateScreen> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late DateTime _selectedDate;
  late List<SelectableItem<Wallet>> _walletItems;
  Wallet? _selectedWallet;

  late TextEditingController _categoryController;
  CashFlowCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _dateController = TextEditingController();
    _selectedDate = DateTime.now();
    _walletItems = widget.wallets
        .map((wallet) => SelectableItem(text: wallet.name, value: wallet))
        .toList();
    _categoryController = TextEditingController();
    updateSelectedDate(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void updateSelectedCategory(CashFlowCategory? newCategory) {
    setState(() {
      _selectedCategory = newCategory;
      _categoryController.text = newCategory == null ? "" : newCategory.name;
    });
  }

  void close() {
    CashTransaction? transaction;
    if (_amountController.text.isNotEmpty &&
        _selectedCategory != null &&
        _selectedWallet != null) {
      double amount = double.parse(_amountController.text);
      transaction = CashTransaction(
          id: 0,
          walletId: _selectedWallet!.id,
          categoryId: _selectedCategory!.id,
          amount: amount,
          description: _descriptionController.text,
          date: _selectedDate);
    }

    Navigator.pop(context, transaction);
  }

  void updateSelectedDate(DateTime newDate) {
    DateFormat format = DateFormat("E, MMMM dd");
    String dateString = format.format(newDate);

    setState(() {
      _selectedDate = newDate;
      _dateController.text = dateString;
    });
  }

  void onWalletChanged(Wallet wallet) {
    setState(() {
      _selectedWallet = wallet;
    });
  }

  @override
  Widget build(BuildContext context) {
    void cancel() {
      Navigator.pop(context, null);
    }

    void openDatePicker() async {
      DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now());

      if (newDate == null) {
        return;
      }

      updateSelectedDate(newDate);
    }

    void openCategorySelection() async {
      SelectCategoryResult? result =
          await showModalBottomSheet<SelectCategoryResult>(
              context: context,
              builder: (BuildContext context) {
                return SelectCategory(categories: widget.categories);
              });

      if (result == null) return;

      updateSelectedCategory(result.category);
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: cancel,
          ),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 15),
                child:
                    FilledButton(onPressed: close, child: const Text("Save"))),
          ],
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              InputRow(
                  child: TextField(
                style: Theme.of(context).textTheme.headlineSmall,
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: const InputDecoration(
                    hintText: "Cost", border: InputBorder.none),
              )),
              const Divider(),
              InputRow(
                  icon: _selectedCategory == null
                      ? Container()
                      : SizedBox(
                          height: 40,
                          width: 40,
                          child: CashFlowCategoryIcon(
                              category: _selectedCategory!)),
                  child: TextField(
                    controller: _categoryController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    readOnly: true,
                    onTap: openCategorySelection,
                    decoration: const InputDecoration(
                        hintText: "Select a category",
                        border: InputBorder.none),
                  )),
              const Divider(),
              InputRow(
                  icon: const Icon(Icons.wallet),
                  child: Container(
                      margin:
                          const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                      child: SelectItem<Wallet>(
                          items: _walletItems,
                          initialSelection: _walletItems[0],
                          onChanged: onWalletChanged))),
              const Divider(),
              InputRow(
                  icon: const Icon(Icons.calendar_today),
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: openDatePicker,
                    decoration: const InputDecoration(border: InputBorder.none),
                  )),
              InputRow(
                  icon: const Icon(Icons.notes),
                  child: TextField(
                    controller: _descriptionController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                        hintText: "Add a description",
                        border: InputBorder.none),
                  )),
              const Divider()
            ],
          ),
        ));
  }
}
