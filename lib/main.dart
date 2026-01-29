import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoCalc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Orbitron',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
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
  final CalculatorLogic _calculator = CalculatorLogic();
  String _display = '0';
  String _expression = '';
  bool _isScientificMode = false;

  void _onButtonPressed(String value) {
    setState(() {
      String result = _calculator.processInput(value);
      _display = result;
      _expression = _calculator.getExpression();
    });
  }

  void _toggleMode() {
    setState(() {
      _isScientificMode = !_isScientificMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeoCalc', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isScientificMode ? Icons.calculate : Icons.functions,
              color: Colors.cyanAccent,
            ),
            onPressed: _toggleMode,
            tooltip: _isScientificMode ? 'Modo Básico' : 'Modo Científico',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E21), Color(0xFF1A1E33)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Pantalla
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _display,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Zona de botones
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: _isScientificMode
                    ? _buildScientificLayout()
                    : _buildBasicLayout(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicLayout() {
    return Column(
      children: [
        _buildButtonRow(['AC', '±', '%', '÷']),
        const SizedBox(height: 8),
        _buildButtonRow(['7', '8', '9', '×']),
        const SizedBox(height: 8),
        _buildButtonRow(['4', '5', '6', '-']),
        const SizedBox(height: 8),
        _buildButtonRow(['1', '2', '3', '+']),
        const SizedBox(height: 8),
        _buildButtonRow(['0', '.', 'DEL', '=']),
      ],
    );
  }

  Widget _buildScientificLayout() {
    return Column(
      children: [
        _buildButtonRow(['sin', 'cos', 'tan', 'AC']),
        const SizedBox(height: 6),
        _buildButtonRow(['ln', 'log', '√', 'π']),
        const SizedBox(height: 6),
        _buildButtonRow(['x²', 'x³', 'xʸ', 'e']),
        const SizedBox(height: 6),
        _buildButtonRow(['(', ')', '%', '÷']),
        const SizedBox(height: 6),
        _buildButtonRow(['7', '8', '9', '×']),
        const SizedBox(height: 6),
        _buildButtonRow(['4', '5', '6', '-']),
        const SizedBox(height: 6),
        _buildButtonRow(['1', '2', '3', '+']),
        const SizedBox(height: 6),
        _buildButtonRow(['0', '.', 'DEL', '=']),
      ],
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) {
          return Expanded(
            flex: btn == '0' ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: NeonButton(
                text: btn,
                onPressed: () => _onButtonPressed(btn),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const NeonButton({super.key, required this.text, required this.onPressed});

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _pressed = false;

  Color _getGlowColor() {
    if (['+', '-', '×', '÷', '='].contains(widget.text)) {
      return Colors.greenAccent;
    } else if (['sin', 'cos', 'tan', 'log', 'ln', '√', 'x²', 'x³', 'xʸ'].contains(widget.text)) {
      return Colors.blueAccent;
    } else if (['AC', 'DEL', '±', '%'].contains(widget.text)) {
      return Colors.deepPurpleAccent;
    } else {
      return Colors.cyanAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = _getGlowColor();
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.selectionClick();
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _pressed ? glowColor.withOpacity(0.25) : Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: glowColor.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(_pressed ? 0.4 : 0.2),
              blurRadius: _pressed ? 8 : 12,
              spreadRadius: 0.5,
            )
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 20,
              color: glowColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// --- LÓGICA DE LA CALCULADORA ---
class CalculatorLogic {
  String _display = '0';
  String _expression = '';
  String _operand1 = '';
  String _operand2 = '';
  String _operator = '';
  // ignore: unused_field
  bool _waitingForOperand = false;
  bool _hasDecimal = false;
  bool _shouldResetDisplay = false;

  String get display => _display;
  String getExpression() => _expression;

  String processInput(String input) {
    switch (input) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        return _inputNumber(input);
      case '.':
        return _inputDecimal();
      case '+':
      case '-':
      case '×':
      case '÷':
        return _inputOperator(input);
      case '=':
        return _calculate();
      case 'AC':
        return _clearAll();
      case 'DEL':
        return _delete();
      case '±':
        return _changeSign();
      case '%':
        return _percentage();
      case 'sin':
        return _trigFunction('sin');
      case 'cos':
        return _trigFunction('cos');
      case 'tan':
        return _trigFunction('tan');
      case 'ln':
        return _logarithm('ln');
      case 'log':
        return _logarithm('log');
      case '√':
        return _squareRoot();
      case 'x²':
        return _power(2);
      case 'x³':
        return _power(3);
      case 'xʸ':
        return _inputOperator('^');
      case 'π':
        return _inputConstant(math.pi);
      case 'e':
        return _inputConstant(math.e);
      default:
        return _display;
    }
  }

  String _inputNumber(String number) {
    if (_shouldResetDisplay || _display == '0') {
      _display = number;
      _shouldResetDisplay = false;
    } else {
      _display += number;
    }
    return _display;
  }

  String _inputDecimal() {
    if (!_hasDecimal) {
      _display += '.';
      _hasDecimal = true;
    }
    return _display;
  }

  String _inputOperator(String op) {
    _operand1 = _display;
    _operator = op;
    _waitingForOperand = true;
    _shouldResetDisplay = true;
    _hasDecimal = false;
    return _display;
  }

  String _calculate() {
    if (_operator.isEmpty) return _display;
    _operand2 = _display;
    double num1 = double.tryParse(_operand1) ?? 0;
    double num2 = double.tryParse(_operand2) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '×':
        result = num1 * num2;
        break;
      case '÷':
        if (num2 == 0) return 'Error';
        result = num1 / num2;
        break;
      case '^':
        result = math.pow(num1, num2).toDouble();
        break;
    }

    _display = _formatResult(result);
    _expression = '$_operand1 $_operator $_operand2 = $_display';
    _operator = '';
    _shouldResetDisplay = true;
    return _display;
  }

  String _clearAll() {
    _display = '0';
    _expression = '';
    _operator = '';
    return _display;
  }

  String _delete() {
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
    return _display;
  }

  String _changeSign() {
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else {
      _display = '-$_display';
    }
    return _display;
  }

  String _percentage() {
    double num = double.tryParse(_display) ?? 0;
    double result = num / 100;
    _display = _formatResult(result);
    _shouldResetDisplay = true;
    return _display;
  }

  String _trigFunction(String func) {
    double num = double.tryParse(_display) ?? 0;
    double rad = num * math.pi / 180;
    double result = 0;
    switch (func) {
      case 'sin':
        result = math.sin(rad);
        break;
      case 'cos':
        result = math.cos(rad);
        break;
      case 'tan':
        result = math.tan(rad);
        break;
    }
    _display = _formatResult(result);
    _shouldResetDisplay = true;
    _expression = '$func($num°) = $_display';
    return _display;
  }

  String _logarithm(String type) {
    double num = double.tryParse(_display) ?? 0;
    if (num <= 0) return 'Error';
    double result = (type == 'ln') ? math.log(num) : math.log(num) / math.log(10);
    _display = _formatResult(result);
    _shouldResetDisplay = true;
    _expression = '$type($num) = $_display';
    return _display;
  }

  String _squareRoot() {
    double num = double.tryParse(_display) ?? 0;
    if (num < 0) return 'Error';
    double result = math.sqrt(num);
    _display = _formatResult(result);
    _shouldResetDisplay = true;
    _expression = '√$num = $_display';
    return _display;
  }

  String _power(int exponent) {
    double num = double.tryParse(_display) ?? 0;
    double result = math.pow(num, exponent).toDouble();
    _display = _formatResult(result);
    _shouldResetDisplay = true;
    _expression = '$num^$exponent = $_display';
    return _display;
  }

  String _inputConstant(double c) {
    _display = _formatResult(c);
    _shouldResetDisplay = true;
    return _display;
  }

  String _formatResult(double result) {
    if (result == result.toInt()) return result.toInt().toString();
    return result.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
