import "package:intl/intl.dart";

String formatWaktu(String publishedAt) {
  final now = DateTime.now();
  final waktuPublish = DateTime.parse(publishedAt);

  final difference = now.difference(waktuPublish);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays <= 5) {
    return '${difference.inDays} days ago';
  } else {
    return DateFormat("d MMMM y", "en_US").format(waktuPublish.toLocal());
  }
}
