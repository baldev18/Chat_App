import 'package:intl/intl.dart';

class Helpers {
  static String formatTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var now = DateTime.now();
    var diff = now.difference(date);

    if (diff.inDays == 0) {
      return formatTime(timestamp);
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
