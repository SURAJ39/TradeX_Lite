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
  String selectedFilter = 'Alphabetical';


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

   _getAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 50, maxWidth: 150),
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
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: isPositive
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "${isPositive ? '+' : ''}${item["change"].toStringAsFixed(2)}%",
                              style: TextStyle(
                                  color: isPositive
                                      ? Colors.greenAccent
                                      : Colors.redAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

  // _getTrendingStocks(List<dynamic> stocks) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Trending Stocks",
  //         style: TextStyle(
  //             color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
  //       ),
  //       const SizedBox(height: 15),
  //       stocks.isEmpty
  //           ? const Center(
  //         child: Padding(
  //           padding: EdgeInsets.all(20),
  //           child: Text("No data found",
  //               style: TextStyle(color: Colors.white54, fontSize: 16)),
  //         ),
  //       )
  //           : Column(
  //         children: stocks.map((item) {
  //           final isPositive = item["change"] >= 0;
  //           return InkWell(
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => StockLandingPage(
  //                     symbol: item["symbol"],
  //                     price: item["price"],
  //                     change: item["change"],
  //                   ),
  //                 ),
  //               );
  //             },
  //             child: Card(
  //               color: const Color(0xFF203A43),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12)),
  //               margin: const EdgeInsets.only(bottom: 10, right: 10),
  //               child: ListTile(
  //                 leading: CircleAvatar(
  //                   backgroundColor: Colors.white.withOpacity(0.2),
  //                   child: Text(item["symbol"][0],
  //                       style: const TextStyle(
  //                           color: Colors.white, fontSize: 16)),
  //                 ),
  //                 title: Text(
  //                   item["symbol"],
  //                   style: const TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 16),
  //                 ),
  //                 trailing: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text("₹${item["price"].toStringAsFixed(2)}",
  //                         style: const TextStyle(color: Colors.grey)),
  //                     Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Icon(
  //                           isPositive
  //                               ? Icons.arrow_upward
  //                               : Icons.arrow_downward,
  //                           color:
  //                           isPositive ? Colors.greenAccent : Colors.redAccent,
  //                           size: 16,
  //                         ),
  //                         const SizedBox(width: 2),
  //
  //                         Text(
  //                           "${isPositive ? '+' : ''}${item["change"].toStringAsFixed(2)}%",
  //                           style: TextStyle(
  //                               color: isPositive
  //                                   ? Colors.greenAccent
  //                                   : Colors.redAccent,
  //                               fontWeight: FontWeight.w400),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }


  _getTrendingStocks(List<dynamic> stocks) {
    List<dynamic> filteredStocks = [...stocks];

    switch (selectedFilter) {
      case 'Alphabetical':
        filteredStocks.sort((a, b) => a["symbol"].compareTo(b["symbol"]));
        break;
      case 'Low to High':
        filteredStocks.sort((a, b) => (a["price"] as double).compareTo(b["price"] as double));
        break;
      case 'High to Low':
        filteredStocks.sort((a, b) => (b["price"] as double).compareTo(a["price"] as double));
        break;
      case 'Up':
        filteredStocks.sort((a, b) => (b["change"] as double).compareTo(a["change"] as double));
        break;
      case 'Down':
        filteredStocks.sort((a, b) => (a["change"] as double).compareTo(b["change"] as double));
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Trending Stocks",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
              onPressed: () {
                _showFilterBottomSheet();
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        filteredStocks.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text("No data found",
                style: TextStyle(color: Colors.white54, fontSize: 16)),
          ),
        )
            : Column(
          children: filteredStocks.map((item) {
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: isPositive
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
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

   _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: commonBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sort / Filter",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // close bottom sheet
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ...[
                'Alphabetical',
                'Low to High',
                'High to Low',
                'Up',
                'Down'
              ].map((filter) {
                return ListTile(
                  title: Text(
                    filter,
                    style: TextStyle(
                        color: selectedFilter == filter
                            ? Colors.greenAccent
                            : Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
