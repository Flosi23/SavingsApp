import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SummaryBarChart extends StatelessWidget {
  const SummaryBarChart({super.key, required this.data});

  final List<BarChartGroupData> data;

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      barGroups: data,
    ));
  }
}
