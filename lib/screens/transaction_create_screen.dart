import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/providers/CategoryProvider.dart';
import 'package:savings_app/widgets/atoms/CashFlowCategoryIcon.dart';
import 'package:savings_app/widgets/atoms/InputRow.dart';
import 'package:savings_app/widgets/atoms/SelectItem.dart';
import 'package:savings_app/widgets/molecules/SelectCategory.dart';
import 'package:uuid/uuid.dart';

class TransactionCreateScreen extends StatefulWidget {
  const TransactionCreateScreen({super.key, required this.wallets});

  final List<Wallet> wallets;

  @override
  State<StatefulWidget> createState() => _TransactionCreateScreenState();
}

class _TransactionCreateScreenState extends State<TransactionCreateScreen> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late DateTime _selectedDate;
  late List<SelectableItem<Wallet>> _walletItems;
  late Wallet _selectedOriginWallet;
  late Wallet _selectedDestinationWallet;

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
    _selectedOriginWallet = widget.wallets[0];
    _selectedDestinationWallet = widget.wallets[0];
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
    List<CashTransaction> transactions = [];

    if (_amountController.text.isNotEmpty && _selectedCategory != null) {
      double amount = double.parse(_amountController.text);

      if (_selectedCategory!.type != CashTransactionType.income) {
        amount *= -1;
      }

      String transferId = const Uuid().v4();

      transactions.add(CashTransaction(
          id: 0,
          transferId: transferId,
          walletId: _selectedOriginWallet.id,
          categoryId: _selectedCategory!.id,
          type: _selectedCategory!.type,
          amount: amount,
          description: _descriptionController.text,
          date: _selectedDate));

      if (_selectedCategory!.type == CashTransactionType.transfer) {
        transactions.add(CashTransaction(
            id: 0,
            transferId: transferId,
            walletId: _selectedDestinationWallet.id,
            categoryId: _selectedCategory!.id,
            type: _selectedCategory!.type,
            amount: amount * -1,
            description: _descriptionController.text,
            date: _selectedDate));
      }
    }

    Navigator.pop(context, transactions);
  }

  void updateSelectedDate(DateTime newDate) {
    DateFormat format = DateFormat("E, MMMM dd");
    String dateString = format.format(newDate);

    setState(() {
      _selectedDate = newDate;
      _dateController.text = dateString;
    });
  }

  void onOriginWalletChanged(Wallet wallet) {
    setState(() {
      _selectedOriginWallet = wallet;
    });
  }

  void onDestinationWalletChanged(Wallet wallet) {
    setState(() {
      _selectedDestinationWallet = wallet;
    });
  }

  @override
  Widget build(BuildContext context) {
    void cancel() {
      Navigator.pop(context, []);
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

    return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
      void openCategorySelection() async {
        CashFlowCategory? result = await showModalBottomSheet<CashFlowCategory>(
            context: context,
            builder: (BuildContext context) {
              return SelectCategory(categories: categoryProvider.categories);
            });

        if (result == null) return;

        updateSelectedCategory(result);
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
                  child: FilledButton(
                      onPressed: close, child: const Text("Save"))),
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
                      border: InputBorder.none, hintText: "Amount"),
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
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectItem<Wallet>(
                                  items: _walletItems,
                                  initialSelection: _walletItems[0],
                                  onChanged: onOriginWalletChanged),
                              Text(
                                _selectedCategory?.type ==
                                        CashTransactionType.transfer
                                    ? "FROM"
                                    : "",
                                style: Theme.of(context).textTheme.labelLarge,
                              )
                            ]))),
                if (_selectedCategory?.type == CashTransactionType.transfer)
                  InputRow(
                      icon: const Icon(Icons.wallet),
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectItem<Wallet>(
                                    items: _walletItems,
                                    initialSelection: _walletItems[0],
                                    onChanged: onDestinationWalletChanged),
                                Text("TO",
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                              ]))),
                const Divider(),
                InputRow(
                    icon: const Icon(Icons.calendar_today),
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: openDatePicker,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
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
    });
  }
}
