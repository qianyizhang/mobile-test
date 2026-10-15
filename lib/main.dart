import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'calculator_engine.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Pocket Calculator',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006B5E),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F7F3),
    ),
    home: const CalculatorScreen(),
  );
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _calculator = CalculatorEngine();
  static const _keys = [
    ['AC', '+/−', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['⌫', '0', '.', '='],
  ];
  static const _labels = {
    'AC': 'Clear all',
    '+/−': 'Change sign',
    '%': 'Percent',
    '÷': 'Divide',
    '×': 'Multiply',
    '−': 'Subtract',
    '+': 'Add',
    '⌫': 'Delete last digit',
    '.': 'Decimal point',
    '=': 'Equals',
  };

  Widget _display() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'POCKET CALCULATOR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Color(0xFF486159),
            ),
          ),
        ),
        const Spacer(),
        Text(
          _calculator.expression,
          key: const ValueKey('expression'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, color: Color(0xFF486159)),
        ),
        const SizedBox(height: 12),
        Semantics(
          label: 'Result',
          value: _calculator.display,
          liveRegion: true,
          excludeSemantics: true,
          child: SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                _calculator.display,
                key: const ValueKey('display'),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF172D27),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _keypad() => Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      children: [
        for (final row in _keys)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final key in row)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Semantics(
                        label: _labels[key] ?? key,
                        button: true,
                        excludeSemantics: true,
                        onTap: () => setState(() => _calculator.press(key)),
                        child: FilledButton(
                          key: ValueKey('key-$key'),
                          onPressed: () =>
                              setState(() => _calculator.press(key)),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            maximumSize: const Size(
                              double.infinity,
                              double.infinity,
                            ),
                            padding: const EdgeInsets.all(4),
                            backgroundColor: key == '='
                                ? const Color(0xFF006B5E)
                                : ['÷', '×', '−', '+'].contains(key)
                                ? const Color(0xFFD2E9DD)
                                : ['AC', '+/−', '%', '⌫'].contains(key)
                                ? const Color(0xFFE4E9E0)
                                : Colors.white,
                            foregroundColor: key == '='
                                ? Colors.white
                                : const Color(0xFF172D27),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: key == '⌫'
                                ? const Icon(Icons.backspace_outlined, size: 26)
                                : Text(
                                    key,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final landscape =
              constraints.maxWidth > 600 &&
              constraints.maxWidth > constraints.maxHeight;
          final scale = MediaQuery.textScalerOf(context).scale(1);
          final minHeight =
              (landscape ? 330.0 : 540.0) + math.max(0, scale - 1) * 180;
          return SingleChildScrollView(
            child: SizedBox(
              height: math.max(constraints.maxHeight, minHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: landscape ? 960 : 480),
                  child: landscape
                      ? Row(
                          children: [
                            Expanded(flex: 4, child: _display()),
                            Expanded(flex: 6, child: _keypad()),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(flex: 4, child: _display()),
                            Expanded(flex: 6, child: _keypad()),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
