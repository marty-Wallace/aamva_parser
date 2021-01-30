
import 'model/card_type.dart';

DateTime parseDate(String dateString, String country) {
  if(country.toUpperCase() == 'USA' && dateString.length >= 8) {
    var year = int.parse(dateString.substring(4, 8));
    var month = int.parse(dateString.substring(0, 2));
    var day = int.parse(dateString.substring(2, 4));
    return DateTime(year, month, day);
  } else {
    var year = int.parse(dateString.substring(0, 4));
    var month = int.parse(dateString.substring(4, 6));
    var day = int.parse(dateString.substring(6, 8));
    return DateTime(year, month, day);
  }
}

void checkCountry(String country) {
  if(country != 'CAN' && country != 'USA') {
    throw new FormatException("Unsupported Country");
  }
}

CardType assumeCardType(String vehicleClass, String restrictions, String endorsements) {
  return vehicleClass == null && restrictions == null && endorsements == null ? CardType.ID : CardType.DL;
}

