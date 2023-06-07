import 'package:flutter/material.dart';

class SelectableItem<T> {
  const SelectableItem({required this.text, required this.value});

  final String text;
  final T value;
}

class SelectItem<T> extends StatefulWidget {
  const SelectItem(
      {super.key,
      required this.items,
      required this.initialSelection,
      required this.onChanged});

  final void Function(T value) onChanged;
  final List<SelectableItem<T>> items;
  final SelectableItem<T> initialSelection;

  @override
  State<StatefulWidget> createState() => _SelectItemState<T>();
}

class _SelectItemState<T> extends State<SelectItem<T>> {
  late SelectableItem<T> selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialSelection;
  }

  void onChanged(SelectableItem<T>? item) {
    if (item == null) {
      return;
    }

    setState(() {
      selectedItem = item;
    });
    widget.onChanged(item.value);
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 25;

    return IntrinsicWidth(
        child: DropdownButtonFormField(
            decoration: InputDecoration(
                hoverColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                )),
            items: widget.items
                .map((SelectableItem<T> item) =>
                    DropdownMenuItem(value: item, child: Text(item.text)))
                .toList(),
            value: selectedItem,
            borderRadius: BorderRadius.circular(25),
            onChanged: onChanged,
            isDense: true,
            focusColor: Colors.transparent,
            icon: const Icon(Icons.expand_more)));
  }
}
