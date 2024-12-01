import 'package:flutter/material.dart';

void main() {
  runApp(UnitConversionApp());
}

class UnitConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UnitConverter(),
    );
  }
}

class UnitConverter extends StatefulWidget {
  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  // Conversion Categories
  final List<String> _categories = ['Length', 'Weight', 'Temperature', 'Currency'];

  // Unit Mapping
  final Map<String, List<String>> _units = {
    'Length': ['Meters', 'Kilometers', 'Miles'],
    'Weight': ['Kilograms', 'Pounds'],
    'Temperature': ['Celsius', 'Fahrenheit'],
    'Currency': ['USD', 'EUR'],
  };

  // State Variables
  String _selectedCategory = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double? _inputValue;
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.teal[50], // Light background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Dropdown
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _fromUnit = _units[_selectedCategory]![0];
                    _toUnit = _units[_selectedCategory]![1];
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // From and To Unit Dropdowns
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _fromUnit,
                      items: _units[_selectedCategory]!.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _fromUnit = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _toUnit,
                      items: _units[_selectedCategory]!.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _toUnit = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Input TextField
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _inputValue = double.tryParse(value);
                });
              },
            ),

            const SizedBox(height: 16),

            // Convert Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _result = _convert();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Convert',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result Display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                _result.isEmpty ? 'Result will appear here' : _result,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _convert() {
    if (_inputValue == null) {
      return 'Please enter a valid value';
    }

    double convertedValue;

    switch (_selectedCategory) {
      case 'Length':
        convertedValue = _convertLength(_inputValue!);
        break;
      case 'Weight':
        convertedValue = _convertWeight(_inputValue!);
        break;
      case 'Temperature':
        convertedValue = _convertTemperature(_inputValue!);
        break;
      case 'Currency':
        convertedValue = _convertCurrency(_inputValue!);
        break;
      default:
        return 'Invalid conversion';
    }

    return 'Result: ${convertedValue.toStringAsFixed(2)} $_toUnit';
  }

  double _convertLength(double value) {
    if (_fromUnit == 'Meters' && _toUnit == 'Kilometers') return value / 1000;
    if (_fromUnit == 'Kilometers' && _toUnit == 'Meters') return value * 1000;
    if (_fromUnit == 'Miles' && _toUnit == 'Kilometers') return value * 1.60934;
    if (_fromUnit == 'Kilometers' && _toUnit == 'Miles') return value / 1.60934;
    return value; // Same unit
  }

  double _convertWeight(double value) {
    if (_fromUnit == 'Kilograms' && _toUnit == 'Pounds') return value * 2.20462;
    if (_fromUnit == 'Pounds' && _toUnit == 'Kilograms') return value / 2.20462;
    return value; // Same unit
  }

  double _convertTemperature(double value) {
    if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') return (value * 9 / 5) + 32;
    if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') return (value - 32) * 5 / 9;
    return value; // Same unit
  }

  double _convertCurrency(double value) {
    if (_fromUnit == 'USD' && _toUnit == 'EUR') return value * 0.85; // Example rate
    if (_fromUnit == 'EUR' && _toUnit == 'USD') return value / 0.85; // Example rate
    return value; // Same unit
  }
}
