import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_calculator/calculator_engine.dart';

void main() {
  late CalculatorEngine calculator;
  void keys(List<String> values) {
    for (final key in values) {
      calculator.press(key);
    }
  }

  void number(String value) => keys(value.split(''));

  setUp(() => calculator = CalculatorEngine());

  test('starts clear and ignores unsupported keys', () {
    expect(calculator.display, '0');
    expect(calculator.expression, '');
    keys(['unknown', '=', '⌫']);
    expect(calculator.display, '0');
  });
  test('arithmetic operators and expression', () {
    keys(['8', '−', '3', '=']);
    expect(calculator.display, '5');
    expect(calculator.expression, '8 − 3 =');
    keys(['×', '4', '=']);
    expect(calculator.display, '20');
    keys(['÷', '5', '=']);
    expect(calculator.display, '4');
    keys(['+', '2', '=']);
    expect(calculator.display, '6');
  });
  test('executes left to right without precedence', () {
    keys(['2', '+', '3', '×', '4', '=']);
    expect(calculator.display, '20');
  });
  test('replaces a pending operator', () {
    keys(['9', '+', '×', '2', '=']);
    expect(calculator.display, '18');
  });
  test('repeated equals repeats the last operation', () {
    keys(['2', '+', '3', '=', '=', '=']);
    expect(calculator.display, '11');
    expect(calculator.expression, '8 + 3 =');
  });
  test('equals without right operand uses the left operand', () {
    keys(['4', '+', '=', '=']);
    expect(calculator.display, '12');
  });
  test('decimal arithmetic has a friendly display', () {
    keys(['.', '1', '+', '.', '2', '=']);
    expect(calculator.display, '0.3');
    keys(['AC', '1', '÷', '3', '=']);
    expect(calculator.display, '0.333333333333');
  });
  test('one decimal point and no redundant leading zeros', () {
    keys(['0', '0', '3', '.', '.', '0', '5']);
    expect(calculator.display, '3.05');
  });
  test('entry is bounded to twelve digits', () {
    number('12345678901234567');
    expect(calculator.display, '123456789012');
  });
  test('backspace edits entry and handles a negative sign', () {
    keys(['1', '2', '+/−', '⌫']);
    expect(calculator.display, '-1');
    calculator.press('⌫');
    expect(calculator.display, '0');
    keys(['.', '5', '⌫']);
    expect(calculator.display, '0.');
  });
  test('backspace does not change a completed result or pending operand', () {
    keys(['2', '+', '3', '=', '⌫']);
    expect(calculator.display, '5');
    keys(['×', '⌫', '2', '=']);
    expect(calculator.display, '10');
  });
  test('sign toggles and allows negative fractional entries', () {
    keys(['.', '+/−', '5', '+', '2', '=']);
    expect(calculator.display, '1.5');
    calculator.press('+/−');
    expect(calculator.display, '-1.5');
    keys(['AC', '+/−']);
    expect(calculator.display, '0');
  });
  test('standalone and contextual percentages', () {
    number('50');
    calculator.press('%');
    expect(calculator.display, '0.5');
    calculator.press('AC');
    number('200');
    keys(['+', '1', '0', '%', '=']);
    expect(calculator.display, '220');
    calculator.press('AC');
    number('200');
    keys(['−', '1', '0', '%', '=']);
    expect(calculator.display, '180');
    calculator.press('AC');
    number('200');
    keys(['×', '1', '0', '%', '=']);
    expect(calculator.display, '20');
  });
  test('a digit replaces a percent result', () {
    keys(['5', '%', '2']);
    expect(calculator.display, '2');
  });
  test('new entry after equals clears repetition', () {
    keys(['2', '+', '3', '=', '7', '=']);
    expect(calculator.display, '7');
    expect(calculator.expression, '');
  });
  test('AC resets pending operations and repetition', () {
    keys(['2', '+', '3', '=', 'AC', '=']);
    expect(calculator.display, '0');
    expect(calculator.expression, '');
  });
  test('division by zero produces a recoverable error', () {
    keys(['8', '÷', '0', '=']);
    expect(calculator.display, 'Error');
    expect(calculator.expression, contains('AC'));
    keys(['=', '+', '%']);
    expect(calculator.display, 'Error');
    keys(['2', '+', '3', '=']);
    expect(calculator.display, '5');
    keys(['÷', '0', '=', '⌫']);
    expect(calculator.display, '0');
  });
  test('zero divided by zero and decimal error recovery', () {
    keys(['0', '÷', '0', '=', '.', '5']);
    expect(calculator.display, '0.5');
  });
  test('large and tiny results use compact scientific notation', () {
    number('999999999999');
    keys(['×', '9', '=']);
    expect(calculator.display, '8.99999999999e12');
    calculator.press('AC');
    number('0.000000001');
    keys(['÷', '1', '0', '=']);
    expect(calculator.display, '1e-10');
  });
  test('overflow becomes an error rather than Infinity', () {
    number('999999999999');
    keys(['×']);
    number('999999999999');
    calculator.press('=');
    for (var i = 0; i < 30; i++) {
      calculator.press('=');
    }
    expect(calculator.display, 'Error');
    calculator.press('AC');
    expect(calculator.display, '0');
  });
}
