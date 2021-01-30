
import 'card_type.dart';
import 'height.dart';
import 'sex.dart';
import 'weight.dart';

class LicenseData {
  String licenseNumber;
  DateTime issueDate;
  DateTime expiry;
  String country;
  String state;
  String city;
  String postal;
  List<String> address;
  String firstName;
  String lastName;
  String middleName;
  String restrictions;
  String endorsements;
  Height height;
  Weight weight;
  String hair;
  String eyes;
  Sex sex;
  String suffix;
  String prefix;
  DateTime dob;
  String issueIdentifier;
  String licenseClass;
  CardType cardType;
}