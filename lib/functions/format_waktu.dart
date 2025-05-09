import "package:intl/intl.dart";

String formatWaktu(String publishedAt) {
  final now = DateTime.now();
  final waktuPublish = DateTime.parse(publishedAt);

  final difference = now.difference(waktuPublish);

  if (difference.inDays >= 1) {
    return DateFormat("d MMMM y", "en_US").format(waktuPublish.toLocal());
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hours ago';
  } else {
    return '${difference.inMinutes} minutes ago';
  }
}
