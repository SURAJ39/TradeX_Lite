
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'global.dart';

class StockLandingPage extends StatefulWidget {
  final String symbol;
  final double price;
  final double change;

  const StockLandingPage({
    super.key,
    required this.symbol,
    required this.price,
    required this.change,
  });

  @override
  State<StockLandingPage> createState() => _StockLandingPageState();
}

class _StockLandingPageState extends State<StockLandingPage> {
  late double currentPrice;
  late double currentChange;
  late List<double> chartPrices;
  Timer? socketTimer;

  @override
  void initState() {
    super.initState();
    currentPrice = widget.price;
    currentChange = widget.change;

    chartPrices = [
      2610, 2620, 2615, 2630, 2640, 2635, 2625, 2635, 2645, 2638,
      2642, 2630, 2638, 2648, 2636, 2635, 2632, 2639, 2644, 2635,
      2642, 2630, 2638, 2648, 2636, 2635, 2632, 2639, 2644, 2635
    ];

    _startSocket();
  }

  void _startSocket() {
    // 2 seconds
    socketTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final random = Random();

      setState(() {
        // price change
        final changePercent = (random.nextDouble() * 2 - 1);
        currentChange = changePercent;
        currentPrice = currentPrice * (1 + changePercent / 100);

        // Update chart
        chartPrices.removeAt(0);
        chartPrices.add(currentPrice);
      });
    });
  }

  @override
  void dispose() {
    socketTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: commonBackgroundColor,
      appBar: _getAppBar(),
      body: _loadDesign(),
    );
  }

  _getAppBar() {
    return AppBar(
      title: const Text(
        "Details",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  _loadDesign() {
    final isPositive = currentChange >= 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getStockPrice(),
          const SizedBox(height: 30),
          _showChart(isPositive),
          const SizedBox(height: 30),
          _marketStatsTable(),
        ],
      ),
    );
  }

  _getStockPrice() {
    final isPositive = currentChange >= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.symbol,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              "₹${currentPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "${isPositive ? '+' : ''}${currentChange.toStringAsFixed(2)}%",
              style: TextStyle(
                color: isPositive ? Colors.greenAccent : Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _showChart(bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "1 Day Chart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 220,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  spots: List.generate(
                    chartPrices.length,
                        (i) => FlSpot(i.toDouble(), chartPrices[i]),
                  ),
                  color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        (isPositive ? Colors.greenAccent : Colors.redAccent)
                            .withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _marketStatsTable() {
    final stats = {
      "Open": "₹2,610.50",
      "High": "₹2,665.20",
      "Low": "₹2,580.40",
      "Close": "₹2,635.50",
      "Volume": "12.4M",
      "Market Cap": "₹17.8T",
    };

    final entries = stats.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Market Stats",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: List.generate(entries.length, (index) {
              final entry = entries[index];
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (index != entries.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        color: Colors.white12,
                        thickness: 1,
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

