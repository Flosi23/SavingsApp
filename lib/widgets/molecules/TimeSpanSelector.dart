import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/widgets/atoms/SelectItem.dart';

enum TimeDuration { week, month, year }

class TimeSpan {
  TimeSpan({required this.start, required this.end});

  DateTime start;
  DateTime end;

  DateTime _changeMonth(DateTime time, int difference) {
    return DateTime(time.year, time.month + difference, 1);
  }

  DateTime _changeYear(DateTime time, int difference) {
    return DateTime(time.year + difference, 1, 1);
  }

  DateTime _changeWeek(DateTime time, int difference) {
    return time.add(Duration(days: difference * 7));
  }

  void change(TimeDuration duration, int difference) {
    DateTime exact = DateTime.now();
    DateTime now = DateTime(exact.year, exact.month, exact.day);

    if (duration == TimeDuration.year) {
      start = _changeYear(now, difference);
      end = _changeYear(now, difference + 1);
      return;
    }

    if (duration == TimeDuration.month) {
      start = _changeMonth(now, difference);
      end = _changeMonth(now, difference + 1);
      return;
    }

    if (duration == TimeDuration.week) {
      start = _changeWeek(now, difference);
      end = _changeWeek(now, difference + 1);
      return;
    }
  }

  String getString(TimeDuration duration) {
    if (duration == TimeDuration.year) {
      DateFormat format = DateFormat("yyyy");
      return format.format(start);
    }

    if (duration == TimeDuration.month) {
      DateFormat format = DateFormat("MMMM yyyy");
      return format.format(start);
    }

    if (duration == TimeDuration.week) {
      DateFormat format = DateFormat("MMMM dd");
      String startDate = format.format(start);
      String endDate = format.format(end);
      return '$startDate - $endDate';
    }

    return "";
  }
}

class TimeSpanSelector extends StatefulWidget {
  TimeSpanSelector({super.key, required this.onChanged});

  final void Function(TimeSpan value) onChanged;
  final List<SelectableItem<TimeDuration>> items = [
    const SelectableItem<TimeDuration>(text: "Weeks", value: TimeDuration.week),
    const SelectableItem<TimeDuration>(
        text: "Months", value: TimeDuration.month),
    const SelectableItem<TimeDuration>(text: "Years", value: TimeDuration.year),
  ];

  @override
  State<StatefulWidget> createState() => _TimespanSelectorState();
}

class _TimespanSelectorState extends State<TimeSpanSelector> {
  int currentPosition = 0;

  late TimeDuration duration = TimeDuration.month;
  late TimeSpan timeSpan;

  @override
  void initState() {
    DateTime now = DateTime.now();
    timeSpan = TimeSpan(
        start: DateTime(now.year, now.month, 1),
        end: DateTime(now.year, now.month + 1, 1));
    super.initState();
  }

  void setTimeSpan() {
    setState(() {
      timeSpan.change(duration, -currentPosition);
      widget.onChanged(timeSpan);
    });
  }

  void onPageChanged(int pagePosition) {
    setState(() {
      currentPosition = pagePosition;
      setTimeSpan();
    });
  }

  void onTimeDurationChanged(TimeDuration timeDuration) {
    setState(() {
      duration = timeDuration;
      setTimeSpan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectItem<TimeDuration>(
            items: widget.items,
            initialSelection: widget.items[1],
            onChanged: onTimeDurationChanged),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 60,
            child: Card(
                elevation: 1,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.chevron_left),
                        Expanded(
                            child: PageView.builder(
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                pageSnapping: true,
                                onPageChanged: onPageChanged,
                                itemBuilder: (content, pagePosition) {
                                  return Center(
                                      child: Text(
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          timeSpan.getString(duration)));
                                })),
                        Icon(
                          Icons.chevron_right,
                          color:
                              currentPosition == 0 ? Colors.transparent : null,
                        )
                      ],
                    ))))
      ],
    );
  }
}
