import 'package:intl/intl.dart';

class HumanFormats {

  // Para popularidad
  static String number(double number){
    final formattedNumber = NumberFormat.compact(
      
    ).format(number);

    return formattedNumber;
  }

  // Para ratings (1 decimal)
  static String decimal(double number){
    return number.toStringAsFixed(1);
  }
}
