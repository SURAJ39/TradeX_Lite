import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'dummy_json.dart';
import 'landing.dart';
import 'settings.dart';
import 'global.dart';

class TradingDashboardPage extends StatefulWidget {
  const TradingDashboardPage({super.key});

  @override
  State<TradingDashboardPage> createState() => _TradingDashboardPageState();
}

class _TradingDashboardPageState extends State<TradingDashboardPage> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  List<Map<String, dynamic>> trendingStocks = [];
  List<Map<String, dynamic>> indexes = [];

  late WebSocketChannel channel;
  bool isSocketConnected = false;
  Timer? updateTimer;

  @override
  void dispose() {
    updateTimer?.cancel();
    channel.sink.close(status.goingAway);
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    trendingStocks =
        List<Map<String, dynamic>>.from(dummyDashboardData["trendingStocks"]);
    indexes = List<Map<String, dynamic>>.from(dummyDashboardData["indexes"]);
    _initSocketConnection();
  }

  void _initSocketConnection() {
    try {
      channel = WebSocketChannel.connect(
        // mock WebSocket taken from google
        Uri.parse('wss://ws.eodhistoricaldata.com/ws/_token=demo'),
      );

      setState(() => isSocketConnected = true);

      _startRealTimeUpdates();
    } catch (e) {
      print("Socket connection failed: $e");
      setState(() => isSocketConnected = false);
    }
  }

  void _startRealTimeUpdates() {
    final random = Random();

    updateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!isSocketConnected) return;

      for (var index in indexes) {
        double change = (-1 + random.nextDouble() * 2);
        double newValue = (index["value"] as double) * (1 + change / 100);
        index["value"] = double.parse(newValue.toStringAsFixed(2));
        index["change"] = double.parse(change.toStringAsFixed(2));
      }

      for (var stock in trendingStocks) {
        double change = (-1 + random.nextDouble() * 2);
        double newPrice = (stock["price"] as double) * (1 + change / 100);
        stock["price"] = double.parse(newPrice.toStringAsFixed(2));
        stock["change"] = double.parse(change.toStringAsFixed(2));
      }

      // Mock message to socket
      channel.sink.add("update:${DateTime.now()}");

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredStocks = isSearching
        ? trendingStocks
            .where((s) => s["symbol"]
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList()
        : trendingStocks;

    return Scaffold(
      backgroundColor: commonBackgroundColor,
      appBar: _getAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getIndexCards(),
            const SizedBox(height: 20),
            _getInvestmentSummary(),
            const SizedBox(height: 20),
            _getTrendingStocks(filteredStocks),
          ],
        ),
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: !isSearching
          ? Row(
              children: [
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  isSocketConnected ? Icons.circle : Icons.circle_outlined,
                  color:
                      isSocketConnected ? Colors.greenAccent : Colors.redAccent,
                  size: 14,
                ),
              ],
            )
          : TextField(
              controller: searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search stock...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: (text) => setState(() {}),
            ),
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search,
              color: Colors.white),
          onPressed: () {
            setState(() {
              if (isSearching) {
                isSearching = false;
                searchController.clear();
              } else {
                isSearching = true;
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }

   _getIndexCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: indexes.map((item) {
          final isPositive = (item["change"] as double) >= 0;
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["name"],
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      item["value"].toStringAsFixed(2),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${isPositive ? '+' : ''}${item["change"].toStringAsFixed(2)}%",
                      style: TextStyle(
                          color: isPositive
                              ? Colors.greenAccent
                              : Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

   _getInvestmentSummary() {
    final data = dummyDashboardData["investmentSummary"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Investment Summary",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _summaryRow("Current Investment", data["currentInvestment"],
                  "Today's P&L", data["todaysPL"]),
              const SizedBox(height: 15),
              _summaryRow("Overall P&L", data["overallPL"], "Available Funds",
                  data["availableFunds"]),
            ],
          ),
        ),
      ],
    );
  }

   _summaryRow(String leftTitle, String leftValue, String rightTitle,
      String rightValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(leftTitle,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(leftValue,
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(rightTitle,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(rightValue,
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ]),
      ],
    );
  }

   _getTrendingStocks(List<dynamic> stocks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Trending Stocks",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 15),
        stocks.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No data found",
                      style: TextStyle(color: Colors.white54, fontSize: 16)),
                ),
              )
            : Column(
                children: stocks.map((item) {
                  final isPositive = item["change"] >= 0;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockLandingPage(
                            symbol: item["symbol"],
                            price: item["price"],
                            change: item["change"],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color(0xFF203A43),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 10, right: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(item["symbol"][0],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ),
                        title: Text(
                          item["symbol"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("₹${item["price"].toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.grey)),
                            Text(
                              "${isPositive ? '+' : ''}${item["change"].toStringAsFixed(2)}%",
                              style: TextStyle(
                                  color: isPositive
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}
