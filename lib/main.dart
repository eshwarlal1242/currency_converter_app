import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // Toggle between light and dark themes
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode, // Apply the selected theme
      home: CurrencyConvert(toggleTheme: _toggleTheme),
    );
  }
}

class CurrencyConvert extends StatefulWidget {
  final VoidCallback toggleTheme;

  const CurrencyConvert({required this.toggleTheme, super.key});

  @override
  State<CurrencyConvert> createState() => _CurrencyConvertState();
}

class _CurrencyConvertState extends State<CurrencyConvert> {
  final accountController = TextEditingController();
  double convertedAmount = 0;
  String? _selectedValue = 'USD';

  // Currency rates
  final Map<String, double> currencyRates = {
    'USD': 276.46,
    'EUR': 292.87,
    'SAR': 74.00,
    'GBP': 352.24,
    'TRY': 7.99,
  };

  // Convert the input amount to the selected currency
  void _convertCurrency() {
    if (accountController.text.isEmpty) {
      _showError('Please enter an amount.');
      return;
    }

    try {
      final amount = double.parse(accountController.text);
      setState(() {
        convertedAmount = amount / (currencyRates[_selectedValue] ?? 1);
      });
    } on FormatException {
      _showError('Invalid input. Please enter a valid number.');
    }
  }

  // Clear the input and reset the result
  void _clearInput() {
    setState(() {
      accountController.clear();
      convertedAmount = 0;
      _selectedValue = 'USD';
    });
  }

  // Display an error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white24,
        title: const Text('Currency Converter App'),

        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: accountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount in PKR',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedValue,
              isExpanded: true,
              items: currencyRates.keys.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Convert',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Converted Amount: ${_selectedValue != null ? _selectedValue! : ''} ${convertedAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearInput,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shadowColor: Colors.black,
                elevation: 5,
              ),
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
