import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '';
  String _currentInput = '';
  double _result = 0.0;
  @override
  void initState() {
    super.initState();
    // Initialize any necessary state here
    _output = '0'; // Set initial value to '0'
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _currentInput = '';
        _output = '0';
        _result = 0;
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_currentInput);
          ContextModel cm = ContextModel();
          _result = exp.evaluate(EvaluationType.REAL, cm);

          // Check if the result is an integer
          if (_result % 1 == 0) {
            _output = _result.toInt().toString(); // Display as integer
          } else {
            _output = _result.toStringAsFixed(7); // Display as decimal
          }
          if (_result % 1 == 0) {
            _currentInput = _result.toInt().toString(); // Display as integer
          } else {
            _currentInput = _result.toStringAsFixed(7); // Display as decimal
          }
        } catch (e) {
          _output = 'Error';
        }
      } else {
        _currentInput += buttonText;
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color color = Colors.white}) {
    Color textColor = color == Colors.white ? Colors.black : Colors.white;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24.0, color: textColor),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: const TextStyle(fontSize: 48.0),
                ),
              ),
            ),
            Row(
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/', color: Colors.black),
              ],
            ),
            Row(
              children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('*', color: Colors.black),
              ],
            ),
            Row(
              children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-', color: Colors.black),
              ],
            ),
            Row(
              children: [
                _buildButton('0'),
                _buildButton('C', color: Colors.black),
                _buildButton('=', color: Colors.black),
                _buildButton('+', color: Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
