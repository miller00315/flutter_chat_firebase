import 'package:intl/intl.dart';

String formatDate(int timeInMillis) {
  var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  return DateFormat.yMMMd().format(date);
}
