import 'package:flutter/material.dart';

import 'global.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  String selectedInterval = '5s';
  final List<String> intervals = ['5s', '10s', '30s'];

  String selectedCurrency = 'INR';
  final List<String> currencies = ['INR', 'USD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: commonBackgroundColor,
      appBar: _getAppBar(),
      body: _loadDesign(),
    );
  }

  _getAppBar() {
    return  AppBar(
      title: const Text(
        "Setting",
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _darkModeButton(),
          const Divider(color: Colors.white30),

          const SizedBox(height: 20),
          _refreshInterval(),

          const Divider(color: Colors.white30),
          const SizedBox(height: 30),
          _currency(),
          const SizedBox(height: 30),

        ],
      ),
    );
  }

  _darkModeButton() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dark Mode',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Switch(
          inactiveTrackColor: Colors.grey,
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
            });
          },
        ),
      ],
    );
  }

   _refreshInterval() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Refresh Interval',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: selectedInterval,
          dropdownColor: const Color(0xFF203A43),
          style: const TextStyle(color: Colors.white),
          items: intervals
              .map((interval) => DropdownMenuItem(
            value: interval,
            child: Text(interval),
          ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedInterval = value;
              });
            }
          },
        ),
      ],
    );
  }

   _currency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Currency Display',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: selectedCurrency,
          dropdownColor: const Color(0xFF203A43),
          style: const TextStyle(color: Colors.white),
          items: currencies
              .map((currency) => DropdownMenuItem(
            value: currency,
            child: Text(currency),
          ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCurrency = value;
              });
            }
          },
        ),
      ],
    );
  }


}
