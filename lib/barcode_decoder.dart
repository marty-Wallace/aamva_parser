
import 'package:aamva_parser/model/height.dart';
import 'package:aamva_parser/model/sex.dart';
import 'package:aamva_parser/model/weight.dart';
import 'package:aamva_parser/string_utils.dart';

import 'license_utils.dart';
import 'model/license_data.dart';

abstract class BarcodeDecoder {
  LicenseData decode(Map<String, String> fields);

  Height getHeightFromString(String heightString) {
    var heightUnit;
    if (heightString.substring(heightString.length - 2, heightString.length) == 'in') {
      heightUnit = HeightUnit.IN;
    } else if (heightString.substring(heightString.length - 2, heightString.length) == 'cm') {
      heightUnit = HeightUnit.CM;
    } else {
      throw new FormatException("Invalid height unit");
    }
    heightString = heightString.substring(0, 3);
    if(!isNumeric(heightString)) {
      throw new FormatException("Height is not numeric");
    }
    return Height(int.parse(heightString), heightUnit);
  }
}

class BarcodeDecoderV1 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {
    throw new UnimplementedError("Version 1 has not been implemented yet");
  }
}

class BarcodeDecoderV3 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {

    var country = fields['DCG'];
    checkCountry(country);


    var expiry = parseDate(fields['DBA'], country);
    var issueDate = parseDate(fields['DBD'], country);
    var dob = parseDate(fields['DBB'], country);

    var vehicleClass = fields['DCA'];
    var restrictions = fields['DCB'];
    var endorsements = fields['DCD'];
    var cardType = assumeCardType(vehicleClass, restrictions, endorsements);

    var sex = sexFromString(fields['DBC']);

    Height height;
    var heightString= fields['DAU'];
    HeightUnit heightUnit;
    // some v3 barcodes wrongly omit height
    if(heightString != null && heightString.length > 1 ) {
      height = getHeightFromString(heightString);
    } else {
      // Indiana apparently put height into a different field and has feet and inches rather than just inches
      heightString = fields['ZIJ'];
      if( heightString != null && heightString.contains('-')) {
        var feet = heightString.split('-')[0];
        var inches = heightString.split('-')[1];
        if(isNumeric(feet) && isNumeric(inches)) {
          height = Height(int.parse(feet) * 12 + int.parse(inches), HeightUnit.IN);
        } else {
          throw new FormatException("Height is not numeric");
        }
      } else {
        height = null;
      }
    }

    var eyes = fields['DAY'];
    var hair = fields['DAZ'];
    if(hair == null) {
      // Indiana has hair in the wrong field apparently
      hair = fields['ZIL'];
    }

    var suffix = fields['DCU'];

    var weightString = fields['DCE'];
    if(weightString == null) {
      weightString = fields['ZIK'];
      if( weightString != null && !isNumeric(weightString)) {
        throw new FormatException("Non numeric weight");
      }
    } else {
      if(!isNumeric(weightString)) {
        throw new FormatException("Non numeric weight");
      }
    }
    var weight;
    if(weightString != null && weightString.trim().length > 0 && isNumeric(weightString)) {
      weight = Weight(int.parse(weightString),
          Weight.inferWeightUnitFromHeightUnit(heightUnit));
    }


    if( fields['DCT'] == null) {
      throw new FormatException("No name field");
    }

    String firstName, middleName;
    var names = fields['DCT'].split(',');
    firstName = names[0];
    if(names.length > 1) {
      middleName = names.sublist(1).join(" ");
    }

    // again indiana apparently uses spaces rather than commas
    if(!fields['DCT'].contains(',')) {
      var names = fields['DCT'].split(' ');
      firstName = names[0];
      if(names.length > 1) {
        middleName = names.sublist(1).join(" ");
      }
    }

    //TODO: not too sure what to do with the ON version of this which also has commas on it for now just taking the first entry
    var lastName = fields['DCS'].split(',')[0];

    List<String> addresses = [];

    String address = fields['DAG'];
    String address2 = fields['DAH'];
    addresses.add(address);
    if( address2 != null && address2.trim().length > 0) {
      addresses.add(address2);
    }
    String city = fields['DAI'];
    String state = fields['DAJ'];
    String postal = fields['DAK'];

    String licenseNumber = fields['DAQ'];

    // String document = fields['DCF'];

    var data = LicenseData();
    // TODO don't use null coalescence on mandatory fields
    data.country = country?.trim();
    data.expiry = expiry;
    data.issueDate = issueDate;
    data.licenseClass = vehicleClass?.trim();
    data.restrictions = restrictions?.trim();
    data.endorsements = endorsements?.trim();
    data.sex = sex;
    data.dob = dob;
    data.height = height;
    data.eyes = eyes?.trim();
    data.hair = hair?.trim();
    data.weight = weight;

    // no prefix in v3
    data.suffix = suffix?.trim();
    data.firstName = firstName.trim();
    data.lastName = lastName.trim();
    data.middleName = middleName?.trim();

    data.address = addresses;
    data.city = city?.trim();
    data.state = state?.trim();
    data.postal = postal?.trim();
    data.licenseNumber = licenseNumber?.trim();
    data.cardType = cardType;
    return data;

  }

}

class BarcodeDecoderV4 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {
    throw new UnimplementedError("Version 4 has not been implemented yet");
  }
}

class BarcodeDecoderV5 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {
    throw new UnimplementedError("Version 5 has not been implemented yet");
  }
}

class BarcodeDecoderV6 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {
    throw new UnimplementedError("Version 6 has not been implemented yet");
  }
}

class BarcodeDecoderV7 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {
    throw new UnimplementedError("Version 7 has not been implemented yet");
  }
}

class BarcodeDecoderV8 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {
    throw new UnimplementedError("Version 8 has not been implemented yet");
  }
}

class BarcodeDecoderV9 extends BarcodeDecoder {
  @override
  LicenseData decode(Map<String, String> fields) {
    var country = fields['DCG'];
    checkCountry(country);

    var lastName = fields['DCS'].trim();
    var middleName = fields['DAD'].trim();
    var firstName = fields['DAC'].trim();

    if(fields['DDE'] == 'T') {
      lastName += "…";
    }
    if(fields['DDF'] == 'T') {
      firstName += "…";
    }
    if(fields['DDG'] == 'T') {
      middleName += "…";
    }

    var dbaString = fields['DBA'];
    var expiry = parseDate(dbaString, country);

    var dbdString = fields['DBD'];
    var issueDate = parseDate(dbdString, country);

    var dbbString = fields['DBB'];
    var dob = parseDate(dbbString, country);

    var vehicleClass = fields['DCA']?.trim();
    var restrictions = fields['DCB']?.trim();
    var endorsements = fields['DCD']?.trim();
    var cardType = assumeCardType(vehicleClass, restrictions, endorsements);

    var sex = sexFromString(fields['DBC']);

    var eyes = fields['DAY'];

    var height = getHeightFromString(fields['DAU']);

    // weight is optional
    var weight;
    var weightUnit = Weight.inferWeightUnitFromHeightUnit(height.heightUnit);
    if(isNumeric(fields['DAX'])) {
      weight = Weight(int.parse(fields['DAX']), weightUnit);
    } else if(isNumeric(fields['DAW'])) {
      weight = Weight(int.parse(fields['DAW']), weightUnit);
    } else if(isNumeric(fields['DCE'])) {
      weight = Weight(int.parse(fields['DCE']), weightUnit);
    }

    var address2 = fields['DAH'];
    var hair = fields['DAZ'];

    var suffix = fields['DCU'];

    var arrivalDates = {};
    if(fields.containsKey('DDH')) {
      arrivalDates['under_18_until'] = parseDate(fields['DDH'], country);
    }
    if(fields.containsKey('DDI')) {
      arrivalDates['under_19_until'] = parseDate(fields['DDI'], country);
    }
    if(fields.containsKey('DDJ')) {
      arrivalDates['under_20_until'] = parseDate(fields['DDJ'], country);
    }

    var address = fields['DAG'];
    var addresses = [address.trim()];
    if(address2 != null && address2.trim().length > 0) {
      addresses.add(address2.trim());
    }

    var city = fields['DAI'];
    var state = fields['DAJ'];
    var licenseNumber = fields['DAQ'];
    var postal = fields['DAK'];
    // var document = fields['DCF'];

    var data = LicenseData();
    data.country = country?.trim();
    data.expiry = expiry;
    data.issueDate = issueDate;
    data.licenseClass = vehicleClass?.trim();
    data.restrictions = restrictions?.trim();
    data.endorsements = endorsements?.trim();
    data.sex = sex;
    data.dob = dob;
    data.height = height;
    data.eyes = eyes?.trim();
    data.hair = hair?.trim();
    data.weight = weight;

    // no prefix in v9
    data.suffix = suffix?.trim();
    data.firstName = firstName.trim();
    data.lastName = lastName.trim();
    data.middleName = middleName?.trim();

    data.address = addresses;
    data.city = city?.trim();
    data.state = state?.trim();
    data.postal = postal?.trim();
    data.licenseNumber = licenseNumber?.trim();
    data.cardType = cardType;

    return data;
  }


}
