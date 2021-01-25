library aamva_parser;

import 'dart:math';

import 'package:aamva_parser/string_utils.dart';
import 'package:flutter/cupertino.dart';

import 'model/DriversLicense.dart';

enum Format { ANY, MAG, PDF417 }

/// AAMVA DL Parser for .
class AAMVAParser {
  /// Returns [LicenseData] of scannedData
  LicenseData decode(String licenseData, {Format format = Format.ANY}) {
    if (licenseData == null || licenseData.isEmpty) {
      throw new FormatException("licenseData is empty");
    }

    if (format == Format.ANY || format == Format.MAG) {
      try {
        return _parseMagstrip(licenseData);
      } on FormatException catch (formatException) {
        if (format == Format.MAG) {
          rethrow;
        }
      }
    }
    return _parsePDF(licenseData);
  }

  LicenseData _parsePDF(String licenseData) {}

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
      throw FormatException("Name field missing delimeter (\$)");
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
      if( track2List[1].length > 13) {
        licenseNumber =
            track2List[0].substring(6, min(track2List[0].length, 20)) +
                track2List[1].substring(13, min(track2List[1].length, 25));
      } else {
        licenseNumber =
            track2List[0].substring(6, min(track2List[0].length, 20));
      }
    }
    var expiry = "20" + track2List[1].substring(0, 4);
    var dob = track2List[1].substring(4, 12);

    var offset = 0;
    if(state == "BC") {
      offset = 1;
    }

    var postal = track3.substring(offset + 3, offset + 14).trim();
    var licenseClass = track3.substring(offset + 14, offset + 16).trim();
    var restrictions = track3.substring(offset + 16, offset + 26).trim();
    var endorsements = track3.substring(offset + 26, offset + 30).trim();

    var sex = track3.substring(offset + 30, offset + 31).trim();
    var height = track3.substring(offset + 31, offset + 34).trim();
    var weight = track3.substring(offset + 34, offset + 37).trim();
    var hair = track3.substring(offset + 37, offset + 40).trim();
    var eyes = track3.substring(offset + 40, offset + 43).trim();

    if( height != null && height != "" && !isNumeric(height)) {
      throw new FormatException("Height should be numeric");
    }
    if( weight != null && weight != "" && !isNumeric(weight)) {
      throw new FormatException("Weight should be numeric");
    }



    var license = LicenseData();
    license.city = city;
    license.state = state;
    license.address = address;
    license.postal = postal;
    license.secondName = middle;
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


    return license;
  }
}
