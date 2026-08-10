import '../data/mock_data.dart';

/// Formats integer amounts with thin space grouping: `145600` → `145 600 сум`.
String formatAmount(int amount, {String currency = 'сум'}) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write(' ');
    }
  }
  final sign = amount < 0 ? '-' : '';
  return '$sign$buffer $currency';
}

const _monthNamesRu = <String>[
  'Январь',
  'Февраль',
  'Март',
  'Апрель',
  'Май',
  'Июнь',
  'Июль',
  'Август',
  'Сентябрь',
  'Октябрь',
  'Ноябрь',
  'Декабрь',
];

const _monthNamesGenitiveRu = <String>[
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];

String formatMonthYear(DateTime date) {
  return '${_monthNamesRu[date.month - 1]} ${date.year}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String formatTime(DateTime date) =>
    '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

/// History row label, e.g. `Сегодня, 10:30` or `5 июля, 11:15`.
String formatPaymentDateTime(DateTime date, {DateTime? now}) {
  final reference = now ?? MockData.mockNow;
  final sameDay = date.year == reference.year &&
      date.month == reference.month &&
      date.day == reference.day;

  if (sameDay) {
    return 'Сегодня, ${formatTime(date)}';
  }

  return '${date.day} ${_monthNamesGenitiveRu[date.month - 1]}, ${formatTime(date)}';
}
