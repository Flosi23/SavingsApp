import 'package:flutter/material.dart';
import 'package:savings_app/widgets/atoms/NumberStatCard.dart';
import 'package:savings_app/widgets/organisms/pie_chart.dart';

class WalletOverviewScreen extends StatelessWidget {
  const WalletOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    List<SectionData> chartData = [
      SectionData(value: 40, color: Colors.blue, iconData: Icons.add),
      SectionData(value: 25, color: Colors.green, iconData: Icons.remove),
      SectionData(value: 10, color: Colors.teal, iconData: Icons.wallet),
      SectionData(value: 15, color: Colors.yellow, iconData: Icons.timeline),
      SectionData(value: 10, color: Colors.pinkAccent, iconData: Icons.settings),
    ];

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Bargeld"),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Expenses",
                ),
                Tab(
                  text: "Income"
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                 children: [
                   const NumberStatCard(text: "-156.50€", textColor: Colors.redAccent),
                   const SizedBox(height: 60),
                   CategoryPieChart(chartData: chartData)
                 ],
                ),
              ),
              const Center(
                child: Text("It's rainy hereee"),
              ),
            ],
          ),
        )
    );
  }
}