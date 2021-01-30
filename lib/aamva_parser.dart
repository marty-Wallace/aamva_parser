library aamva_parser;

import 'dart:math';

import 'package:aamva_parser/model/height.dart';
import 'package:aamva_parser/model/sex.dart';
import 'package:aamva_parser/model/weight.dart';
import 'package:aamva_parser/string_utils.dart';

import 'barcode_decoder.dart';
import 'model/license_data.dart';

enum Format { ANY, MAG, PDF417 }

/// AAMVA DL Parser
class AAMVAParser {
  /// Returns [LicenseData] of scannedData
  LicenseData decode(String licenseData, {Format format = Format.ANY}) {
    if (licenseData == null || licenseData.isEmpty) {
      throw new FormatException("licenseData is empty");
    }

    if (format == Format.ANY || format == Format.MAG) {
      try {
        return _parseMagstrip(licenseData);
      } on FormatException {
        if (format == Format.MAG) {
          rethrow;
        }
      }
    }
    return _parsePDF(licenseData);
  }

  static const PDF_LINEFEED = '\x0A'; // '\n' (line feed)
  static const PDF_RECORDSEP = '\x1E'; // record separator
  static const PDF_SEGTERM =
      '\x0D'; // '\r' segment terminator (carriage return)
  static const ISSUERS = {
    636033: 'Alabama',
    646059: 'Alaska',
    604427: 'American Samoa',
    636026: 'Arizona',
    636021: 'Arkansas',
    636028: 'British Columbia',
    636014: 'California',
    636020: 'Colorado',
    636006: 'Connecticut',
    636043: 'District of Columbia',
    636011: 'Delaware',
    636010: 'Florida',
    636055: 'Georgia',
    636019: 'Guam',
    636047: 'Hawaii',
    636050: 'Idaho',
    636035: 'Illinois',
    636037: 'Indiana',
    636018: 'Iowa',
    636022: 'Kansas',
    636046: 'Kentucky',
    636007: 'Louisiana',
    636041: 'Maine',
    636048: 'Manitoba',
    636003: 'Maryland',
    636002: 'Massachusetts',
    636032: 'Michigan',
    636038: 'Minnesota',
    636051: 'Mississippi',
    636030: 'Missouri',
    636008: 'Montana',
    636054: 'Nebraska',
    636049: 'Nevada',
    636017: 'New Brunswick',
    636039: 'New Hampshire',
    636036: 'New Jersey',
    636009: 'New Mexico',
    636001: 'New York',
    636016: 'Newfoundland',
    636004: 'North Carolina',
    636034: 'North Dakota',
    636013: 'Nova Scotia',
    636023: 'Ohio',
    636058: 'Oklahoma',
    636012: 'Ontario',
    636029: 'Oregon',
    636025: 'Pennsylvania',
    604426: 'Prince Edward Island',
    604428: 'Quebec',
    636052: 'Rhode Island',
    636044: 'Saskatchewan',
    636005: 'South Carolina',
    636042: 'South Dakota',
    636053: 'Tennessee',
    636027: 'State Department (USA)',
    636015: 'Texas',
    636062: 'US Virgin Islands',
    636040: 'Utah',
    636024: 'Vermont',
    636000: 'Virginia',
    636045: 'Washington',
    636061: 'West Virginia',
    636031: 'Wisconsin',
    636060: 'Wyoming',
    604429: 'Yukon'
  };

  LicenseData _parsePDF(String licenseData) {
    // strips all the data before the compliance character
    licenseData = "@" + licenseData.split("@").sublist(1).join("@");
    if (licenseData[0] != '@') {
      throw new FormatException("Missing compliance character");
    }
    if (licenseData[1] != PDF_LINEFEED) {
      throw new FormatException("Missing data element seperator");
    }
    if (licenseData[2] != PDF_RECORDSEP) {
      // South Carolina uses a different record separator because they think they are special
      if(licenseData[2] != '\x1c') {
        throw new FormatException(
            "Missing Record Separator (RS) got " + licenseData[2]);
      }
    }
    if (licenseData[3] != PDF_SEGTERM) {
      throw new FormatException("Missing segment terminator (CR)");
    }
    if (licenseData.substring(4, 9) != 'ANSI ' &&
        licenseData.substring(4, 9) != 'AAMVA') {
      throw new FormatException("Wrong file type got " +
          licenseData.substring(4, 9) +
          " should be ANSI");
    }
    var issueIdentifier = licenseData.substring(9, 15);
    if (!isNumeric(issueIdentifier)) {
      throw new FormatException("Issue identifier is not an integer");
    }
    var versionStr = licenseData.substring(15, 17);
    if (!isNumeric(versionStr)) {
      throw new FormatException("Version number is not numeric");
    }
    var version = int.parse(versionStr);

    if (version == 0 || version == 1) {
      // do some stuff
      throw new UnimplementedError("Version 1 of AAMVA spec and before are unsupported");
    } else if (version == 2 || version > 9) {
      throw new FormatException("Unsupported AAMVA version");
    }

    var jurisdictionVersion = licenseData.substring(17, 19);
    if (!isNumeric(jurisdictionVersion)) {
      throw new FormatException(
          "Jurisdiction version number is not an integer");
    }
    var nEntriesStr = licenseData.substring(19, 21);
    if (!isNumeric(nEntriesStr)) {
      throw new FormatException("Number of entries is not an integer");
    }
    var nEntries = int.parse(nEntriesStr);

    var readOffset = 0;
    // var recordType = null;

    var subfiles = [];

    for (int fileId = 0; fileId < nEntries; fileId++) {
      var offsetStr = licenseData.substring(readOffset + 23, readOffset + 27);
      var lengthStr = licenseData.substring(readOffset + 27, readOffset + 31);

      if (!isNumeric(offsetStr)) {
        throw new FormatException("offset is not an integer");
      }
      if (!isNumeric(lengthStr)) {
        throw new FormatException("length is not an integer");
      }

      var offset = int.parse(offsetStr);
      var length = int.parse(lengthStr);

      // for some reason ON drivers licenses have an offset of 0
      if (offset == 0) {
        if (fileId > 0) {
          throw FormatException("No offset for subfile " + fileId.toString());
        }
        var dlLocation = licenseData.indexOf("DL");
        if (dlLocation > 0) {
          offset = dlLocation;
        }
      }

      subfiles.add(licenseData.substring(offset, offset + length));
      readOffset += 10;
    }

    var parsedData = subfiles.join("\n");
    parsedData = trim(parsedData, '\n');
    parsedData = parsedData.split(PDF_SEGTERM).join("");

    var subFile = parsedData.split(PDF_LINEFEED);
    if (subFile[0].substring(0, 2) != 'DL' &&
        subFile[0].substring(0, 2) != 'ID') {
      throw new FormatException("Not an ID or DL");
    }
    subFile[0] = subFile[0].substring(2);
    subFile[subFile.length - 1] =
        trim(subFile[subFile.length - 1], PDF_SEGTERM);

    Map<String, String> fields = {};
    for (var s in subFile) {
      print(s);
      if (s.length > 3) {
        fields[s.substring(0, 3)] = s.substring(3).trim();
      }
    }

    var dl = resolveBarcodeDecoder(version).decode(fields);
    dl.issueIdentifier = issueIdentifier;
    return dl;
  }

  BarcodeDecoder resolveBarcodeDecoder(int version) {
    if (version == 0 || version == 1) {
      return BarcodeDecoderV1();
    }
    if (version == 3) {
      return BarcodeDecoderV3();
    }
    if (version == 4) {
      return BarcodeDecoderV4();
    }
    if (version == 5) {
      return BarcodeDecoderV5();
    }
    if (version == 6) {
      return BarcodeDecoderV6();
    }
    if (version == 7) {
      return BarcodeDecoderV7();
    }
    if (version == 8) {
      return BarcodeDecoderV8();
    }
    if (version == 9) {
      return BarcodeDecoderV9();
    }
    throw new FormatException("Unknown AAMVA version: " + version.toString());
  }

  LicenseData _parseMagstrip(String licenseData) {
    var fields = licenseData.split('^');
    if (fields[0][0] != '%') {
      throw new FormatException("Missing start sentinel character (%)");
    }
    if (fields[0].startsWith('%E?')) {
      throw new FormatException("Error while reading card");
    }
    var state = fields[0].substring(1, 3);
    var city = fields[0].substring(3, min(fields[0].length, 16));

    var namePre;
    List<String> address;
    var remaining;
    if (city.length == 13 && !city.contains('^')) {
      namePre = fields[0].substring(16);
      address = fields[1].split('\$');
      remaining = fields[2];
    } else {
      namePre = fields[1];
      address = [fields[2].split('\$')[0]];
      remaining = fields[3];
    }

    if (namePre.length == 0) {
      throw FormatException("Empty name field");
    }
    if (!namePre.contains("\$")) {
      throw FormatException("Name field missing delimiter (\$)");
    }

    var name = namePre.split("\$");
    var middle;
    if (name.length == 3) {
      middle = name[2];
    }
    name[0] = trim(name[0], ',');

    List<String> remainingList = remaining.split('?');
    remainingList = remainingList.sublist(1, 3);

    if (!remainingList[0].startsWith(';')) {
      throw FormatException("Missing Track 2 start sentinel");
    }
    var track2 = trim(remainingList[0], ";");
    var track2List = track2.split("=");
    var track3 = remainingList[1];

    if (track2List.length != 2 && track2List.length != 3) {
      throw new FormatException("Invalid Track 2 length");
    }

    var issueIdentifier =
    track2List[0].substring(0, min(track2List[0].length, 6));

    String licenseNumber;
    if (track2List.length == 3) {
      licenseNumber = track2List[0].substring(6, min(track2List[0].length, 20));
    } else {
      if (track2List[1].length > 13) {
        licenseNumber =
            track2List[0].substring(6, min(track2List[0].length, 20)) +
                track2List[1].substring(13, min(track2List[1].length, 25));
      } else {
        licenseNumber =
            track2List[0].substring(6, min(track2List[0].length, 20));
      }
    }

    var expiryYear = track2List[1].substring(0, 2);
    var expiryMonth = track2List[1].substring(2, 4);
    if (!isNumeric(expiryYear) || !isNumeric(expiryMonth)) {
      throw new FormatException("Expiry is not numeric");
    }

    // add 1 to month and subtract 1 day to get the last day of the month, tested that this works with month=13 as well
    var expiry = new DateTime(
        2000 + int.parse(expiryYear), int.parse(expiryMonth) + 1).add(
        Duration(days: -1));

    var dobYear = track2List[1].substring(4, 8);
    var dobMonth = track2List[1].substring(8, 10);
    var dobDay = track2List[1].substring(10, 12);
    if (!isNumeric(dobYear) || !isNumeric(dobMonth) || !isNumeric(dobDay)) {
      throw new FormatException("Dob is not numeric");
    }
    var dob = DateTime(
        int.parse(dobYear), int.parse(dobMonth), int.parse(dobDay));

    var offset = 0;
    if (state == "BC") {
      offset = 1;
    }

    var postal = track3.substring(offset + 3, offset + 14).trim();
    var licenseClass = track3.substring(offset + 14, offset + 16).trim();
    var restrictions = track3.substring(offset + 16, offset + 26).trim();
    var endorsements = track3.substring(offset + 26, offset + 30).trim();

    var sexString = track3.substring(offset + 30, offset + 31).trim();
    var sex = sexFromString(sexString);
    var heightString = track3.substring(offset + 31, offset + 34).trim();
    var weightString = track3.substring(offset + 34, offset + 37).trim();

    // Since there is no weight/height units provided, we can assume if the state is a canadian prov/territory then the unit is KG
    var defaultWeightUnit = [ 'BC', 'AB', 'SK', 'MB', 'ON', 'QC', 'NB', 'NS', 'PE', 'NL', 'YT', 'NT', 'NU' ].contains(state) ? WeightUnit.KG : WeightUnit.LBS;
    var defaultHeightUnit = ['BC', 'AB', 'SK', 'MB', 'ON', 'QC', 'NB', 'NS', 'PE', 'NL', 'YT', 'NT', 'NU'].contains(state) ? HeightUnit.CM : HeightUnit.IN;

    var hair = track3.substring(offset + 37, offset + 40).trim();
    var eyes = track3.substring(offset + 40, offset + 43).trim();

    if (heightString != null && heightString != "" &&
        !isNumeric(heightString)) {
      throw new FormatException("Height should be numeric");
    }
    if (weightString != null && weightString != "" &&
        !isNumeric(weightString)) {
      throw new FormatException("Weight should be numeric");
    }
    Height height;
    Weight weight;
    if (heightString != null && weightString.length > 0) {
      height = Height(int.parse(heightString), defaultHeightUnit);
    }
    if (weightString != null && weightString.length > 0) {
      weight = Weight(int.parse(weightString), defaultWeightUnit);
    }

    var license = LicenseData();
    license.city = city;
    license.state = state;
    license.address = address;
    license.postal = postal;
    license.middleName = middle;
    license.firstName = name[1];
    license.lastName = name[0];
    license.licenseNumber = licenseNumber;
    license.expiry = expiry;
    license.restrictions = restrictions;
    license.endorsements = endorsements;
    license.height = height;
    license.weight = weight;
    license.hair = hair;
    license.eyes = eyes;
    license.sex = sex;
    license.suffix = null;
    license.prefix = null;
    license.dob = dob;
    license.issueIdentifier = issueIdentifier;
    license.licenseClass = licenseClass;

    return license;
  }
}
