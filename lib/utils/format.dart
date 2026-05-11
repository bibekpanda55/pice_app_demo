/// Indian numbering format: 1,23,456 (lakh-grouping) — without pulling in
/// the `intl` package for a single helper.
String inr(double amount) {
  final whole = amount.toStringAsFixed(0);
  if (whole.length <= 3) return '₹$whole';
  final last3 = whole.substring(whole.length - 3);
  var rest = whole.substring(0, whole.length - 3);
  final groups = <String>[];
  while (rest.length > 2) {
    groups.add(rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) groups.add(rest);
  return '₹${groups.reversed.join(',')},$last3';
}

const _monthAbbrev = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String shortDate(DateTime d) => '${d.day} ${_monthAbbrev[d.month - 1]}';

String agoLabel(DateTime d) {
  final days = DateTime.now().difference(d).inDays;
  if (days <= 0) return 'today';
  if (days == 1) return 'yesterday';
  if (days < 30) return '$days days ago';
  if (days < 60) return '1 month ago';
  return '${days ~/ 30} months ago';
}
