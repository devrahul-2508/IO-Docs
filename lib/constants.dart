import 'package:intl/intl.dart';
class Constants {
  static String formatDate(String timestamp){
  DateTime dateTime = DateTime.parse(timestamp);
  String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
  return formattedDate;

}
}
