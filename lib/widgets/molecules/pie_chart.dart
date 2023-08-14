import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SectionData {
  double value;
  Color color;
  IconData iconData;

  SectionData(
      {required this.value, required this.color, required this.iconData});
}

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({super.key, required this.chartData});

  final List<SectionData> chartData;

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<CategoryPieChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 5,
            centerSpaceRadius: 70,
            sections: showingSections(),
          ),
          swapAnimationDuration: Duration.zero,
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return widget.chartData.asMap().entries.map((entry) {
      SectionData sectionData = entry.value;

      const radius = 50.0;
      const widgetSize = 40.0;

      return PieChartSectionData(
        color: sectionData.color,
        title: '',
        value: sectionData.value,
        radius: radius,
        badgeWidget: _Badge(
          iconData: sectionData.iconData,
          borderColor: sectionData.color,
          size: widgetSize,
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.iconData,
    required this.borderColor,
    required this.size,
  });

  final IconData iconData;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
          child:
              Icon(iconData, color: Theme.of(context).colorScheme.onSurface)),
    );
  }
}
