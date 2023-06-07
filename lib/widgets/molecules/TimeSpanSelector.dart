import 'package:flutter/cupertino.dart';
import 'package:savings_app/widgets/atoms/SelectItem.dart';

enum Timespan { week, month, year }

class TimespanSelector extends StatelessWidget {
  TimespanSelector({super.key, required this.onChanged});

  final void Function(Timespan value) onChanged;

  final List<SelectableItem<Timespan>> items = [
    const SelectableItem<Timespan>(text: "Week", value: Timespan.week),
    const SelectableItem<Timespan>(text: "Month", value: Timespan.month),
    const SelectableItem<Timespan>(text: "Year", value: Timespan.year),
  ];

  @override
  Widget build(BuildContext context) {
    return SelectItem<Timespan>(
        items: items, initialSelection: items[1], onChanged: onChanged);
  }
}
