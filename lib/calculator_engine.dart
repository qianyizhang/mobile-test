/// A small, immediate-execution calculator: 2 + 3 × 4 = 20.
/// There is intentionally no operator precedence. Input is capped at 12 digits;
/// results are rounded for display to 12 significant digits. Percent uses the
/// left operand for addition/subtraction (200 + 10 % = 220), and divides the
/// current entry by 100 for multiplication, division, and standalone use.
class CalculatorEngine {
  static const int maxInputDigits = 12;
  String _display = '0';
  String _expression = '';
  double? _left;
  String? _operator;
  String? _repeatOperator;
  double? _repeatOperand;
  bool _newEntry = true;
  bool _waitingForOperand = false;
  bool _error = false;

  String get display => _display;
  String get expression => _expression;

  void press(String key) {
    if (key == 'AC') {
      _clear();
      return;
    }
    if (RegExp(r'^[0-9]$').hasMatch(key) || key == '.') {
      if (_error) _clear();
      _enter(key);
      return;
    }
    if (_error) {
      if (key == '⌫') _clear();
      return;
    }
    switch (key) {
      case '⌫':
        if (_newEntry) return;
        _display = _display.substring(0, _display.length - 1);
        if (_display.isEmpty || _display == '-') _display = '0';
        _updateExpression();
        return;
      case '+/−':
        if (_value != 0 || _display.contains('.')) {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
        _waitingForOperand = false;
        _clearRepeat();
        _updateExpression();
        return;
      case '%':
        var value = _value / 100;
        if (_operator == '+' || _operator == '−') value *= _left!;
        if (!_setResult(value)) return;
        _newEntry = true;
        _waitingForOperand = false;
        _clearRepeat();
        _updateExpression();
        return;
      case '+':
      case '−':
      case '×':
      case '÷':
        _chooseOperator(key);
        return;
      case '=':
        _equals();
        return;
      default:
        return; // Ignore unknown keys instead of corrupting calculator state.
    }
  }

  double get _value => double.parse(_display);

  void _clear() {
    _display = '0';
    _expression = '';
    _left = null;
    _operator = null;
    _newEntry = true;
    _waitingForOperand = false;
    _error = false;
    _clearRepeat();
  }

  void _clearRepeat() {
    _repeatOperator = null;
    _repeatOperand = null;
  }

  void _enter(String key) {
    if (_newEntry) {
      if (_operator == null) {
        _left = null;
        _clearRepeat();
      }
      _display = '0';
      _newEntry = false;
      _waitingForOperand = false;
    }
    if (key == '.') {
      if (!_display.contains('.')) _display += '.';
    } else {
      final digits = _display.replaceAll(RegExp(r'[^0-9]'), '');
      if (_display == '0' || _display == '-0') {
        _display = _display.startsWith('-') ? '-$key' : key;
      } else if (digits.length < maxInputDigits) {
        _display += key;
      }
    }
    _updateExpression();
  }

  void _updateExpression() {
    if (_operator == null) {
      _expression = '';
    } else {
      _expression = '${_format(_left!)} $_operator';
      if (!_waitingForOperand) _expression += ' $_display';
    }
  }

  void _chooseOperator(String key) {
    if (_operator != null && !_waitingForOperand) {
      if (!_setResult(_calculate(_left!, _operator!, _value))) return;
    }
    _left = _value;
    _operator = key;
    _newEntry = true;
    _waitingForOperand = true;
    _clearRepeat();
    _updateExpression();
  }

  void _equals() {
    final op = _operator ?? _repeatOperator;
    if (op == null) return;
    final left = _operator != null ? _left! : _value;
    final right = _operator != null
        ? (_waitingForOperand ? _left! : _value)
        : _repeatOperand!;
    if (!_setResult(_calculate(left, op, right))) return;
    _expression = '${_format(left)} $op ${_format(right)} =';
    _repeatOperator = op;
    _repeatOperand = right;
    _left = null;
    _operator = null;
    _newEntry = true;
    _waitingForOperand = false;
  }

  double _calculate(double left, String op, double right) {
    switch (op) {
      case '+':
        return left + right;
      case '−':
        return left - right;
      case '×':
        return left * right;
      case '÷':
        return right == 0 ? double.nan : left / right;
      default:
        return double.nan;
    }
  }

  bool _setResult(double value) {
    if (!value.isFinite) {
      _clear();
      _display = 'Error';
      _expression = 'Cannot calculate · press AC or enter a number';
      _error = true;
      return false;
    }
    _display = _format(value);
    return true;
  }

  String _format(double value) {
    if (value == 0) return '0';
    // Round before choosing notation, removing binary floating-point noise.
    final rounded = double.parse(value.toStringAsPrecision(12));
    // Rounding a value near double.maxFinite can itself overflow.
    if (!rounded.isFinite) return value.toString();
    final magnitude = rounded.abs();
    if (magnitude >= 1e12 || magnitude < 1e-9) {
      final parts = rounded.toStringAsExponential(11).split('e');
      final mantissa = parts[0].replaceFirst(RegExp(r'\.?0+$'), '');
      return '${mantissa}e${int.parse(parts[1])}';
    }
    return rounded.toString().replaceFirst(RegExp(r'\.0$'), '');
  }
}
