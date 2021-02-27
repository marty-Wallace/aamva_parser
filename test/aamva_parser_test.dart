import 'package:aamva_parser/aamva_parser.dart';
import 'package:aamva_parser/model/card_type.dart';
import 'package:aamva_parser/model/height.dart';
import 'package:aamva_parser/model/sex.dart';
import 'package:aamva_parser/model/weight.dart';
import 'package:test/test.dart';

// faked data or data from jurisdictional authorities
var pdf417 = {
  "aamva_v1": '@\n\x1e\rANSI 6360000102DL00390188ZV02270031DLDAQ0123456789ABC\nDAAPUBLIC,JOHN,Q\nDAG123 MAIN STREET\nDAIANYTOWN\nDAJVA\nDAK123459999  \nDARDM  \nDAS       \nDAT     \nDAU509\nDAW175\nDAYBL \nDAZBR \nDBA20011201\nDBB19761123\nDBCM\nDBD19961201\rZVZVAJURISICTIONDEFINEDELEMENT\r\\928\\111\\100\\180\\605\\739\\922\r\n',
  "aamva_v2": '@\n\x1e\rANSI 6360000102DL00390188ZV02270031DLDAQ0123456789ABC\nDAAPUBLIC,JOHN,Q\nDAG123 MAIN STREET\nDAIANYTOWN\nDAJVA\nDAK123459999  \nDARDM  \nDAS       \nDAT     \nDAU509\nDAW175\nDAYBL \nDAZBR \nDBA20011201\nDBB19761123\nDBCM\nDBD19961201\rZVZVAJURISICTIONDEFINEDELEMENT\r\\928\\111\\100\\180\\605\\739\\922\r\n',

  "va": '@\n\x1e\rANSI 636000030001DL00310440DLDCANONE\nDCB158X9     \nDCDS    \nDBA08142017\nDCSMAURY                                   \nDCTJUSTIN,WILLIAM                                                                  \nDBD08142009\nDBB07151958\nDBC1\nDAYBRO\nDAU075 in\nDAG17 FIRST STREET                    \nDAISTAUNTON            \nDAJVA\nDAK244010000  \nDAQT16700185                \nDCF061234567                \nDCGUSA\nDCHS   \nDDC00000000\nDDB12102008\nDDDN\nDDAN\nDCK9060600000017843         \n\r\r\n',
  "va_under21": '@\n\x1e\rANSI 636000030001DL00310440DLDCANONE\nDCB158X9     \nDCDS    \nDBA08142017\nDCSMAURY                                   \nDCTJUSTIN,WILLIAM                                                                  \nDBD08142009\nDBB07151997\nDBC1\nDAYBRO\nDAU075 in\nDAG17 FIRST STREET                    \nDAISTAUNTON            \nDAJVA\nDAK244010000  \nDAQT16700185                \nDCF061234567                \nDCGUSA\nDCHS   \nDDC00000000\nDDB12102008\nDDDN\nDDAN\nDCK9060600000017843         \n\r\r\n',
  "ga": '@\n\x1e\rANSI 636055060002DL00410288ZG03290093DLDCAC\nDCBB\nDCDNONE\nDBA07012017\nDCSSAMPLE\nDDEU\nDACJANICE\nDDFU\nDADNONE\nDDGU\nDBD07012012\nDBB07011957\nDBC2\nDAYBLU\nDAU064 in\nDAG123 MAIN STREET\nDAIANYTOWN\nDAJGA\nDAK303341234  \nDAQ123456789\nDAW120\nDCF1234509876543210987654321\nDCGUSA\nDCUNONE\nDCK1234567890123456789012345\nDDAF\nDDB01302012\nDDK1\n\rZGZGAN\nZGBN\nZGC5-04\nZGDROCKDALE\nZGEN\nZGFABC123456789-1234567\nZGG12345-67891234567ABC\nZGH000\n\r\r\n',
  "indiana": '@\n\x1e\rANSI 636037040002DL00410514ZI05550117DLDCAX-1X-2\nDCBX-1X-2X-3X-4\nDCDX-1XY\nDBA07042010\nDCSSAMPLEFAMILYNAMEUPTO40CHARACTERSXYWXYWXY\nDACHEIDIFIRSTNAMEUPTO40CHARACTERSXYWXYWXYWX\nDADMIDDLENAMEUPTO40CHARACTERSXYWXYWXYWXYWXY\nDBD07042006\nDBB07041989\nDBC2\nDAYHAZ\nDAU5\'-04"\nDAG123 SAMPLE DRIVE                   \nDAHAPT B                              \nDAIINDIANAPOLIS        \nDAJIN\nDAK462040000  \nDAQ1234-56-7890             \nDCF07040602300001           \nDCGUSA\nDDEN\nDDFN\nDDGN\nDAZBLN         \nDCK12345678900000000000     \nDCUXYWXY\nDAW120\nDDAF\nDDBMMDDCCYY\nDDD1\n\rZIZIAMEDICAL CONDITION\nZIBMEDICAL ALERT\nZIC023\nZIDDONOR\nZIEUNDER 18 UNTIL 07/04/07\nZIFUNDER 21 UNTIL 07/04/10\nZIGOP\n\r\r\n',
  "wa": '@\n\x1e\rANSI 636045030002DL00410239ZW02800053DLDCANONE\nDCBNONE\nDCDNONE\nDBA11042014\nDCSANASTASIA\nDCTPRINCESS MONACO\nDCU\nDBD09142010\nDBB11041968\nDBC2\nDAYGRN\nDAU063 in\nDCE2\nDAG2600 MARTIN WAY E\nDAIOLYMPIA\nDAJWA\nDAK985060000  \nDAQANASTPM320QD\nDCFANASTPM320QDL1102574D1643\nDCGUSA\nDCHNONE\n\rZWZWAL1102574D1643\nZWB\nZWC33\nZWD\nZWE\nZWFRev09162009\n\r\r\n',
  "wa_edl": '@\n\x1e\rANSI 636045030002DL00410232ZW02730056DLDCSO REALTEST\nDCTDABE DEE\nDCUV\nDAG2600 MARTIN WAY\nDAIOLYMPIA\nDAJWA\nDAK985060000  \nDCGUSA\nDAQOREALDD521DS\nDCANONE\nDCBNONE\nDCDNONE\nDCFOREALDD521DSL1083014J1459\nDCHNONE\nDBA03102013\nDBB03101948\nDBC1\nDBD10272008\nDAU070 in\nDCE4\nDAYBLU\n\rZWZWAL1083014J1459\nZWB   \nZWC33\nZWD\nZWE\nZWFRev03122007\n\r\r\n',
  "ca": ' @\n\x1e\rANSI 636014040002DL00410477ZC05180089DLDAQD1234562 XYXYXYXYXYXYXYXYX\nDCSLASTNAMEXYXYXYXYXYXYXYXYXXYXYXYXYXYXYXYX\nDDEU\nDACFIRSTXYXYXYXYXYXYXYXYXXYXYXYXYXYXYXYXXYX\nDDFU\nDADXYXYXYXYXYXYXYXYXXYXYXYXYXYXYXYXXYXYXYXY\nDDGU\nDCAA XYXY\nDCBNONEY1XY1XY1\nDCDNONEX\nDBD10312009\nDBB10311977\nDBA10312014\nDBC1\nDAU068 IN\nDAYBRO\nDAG1234 ANY STREET XY1XY1XY1XY1XY1XY1X\nDAICITY XY1XY1XY1XY1XY1\nDAJCA\nDAK000000000  \nDCF00/00/0000NNNAN/ANFD/YY X\nDCGUSA\nDCUSUFIX\nDAW150\nDAZBLK XY1XY1XY\nDCKXY1XY1XY1XY1XY1XY1XY1XY1X\nDDAF\nDDBMMDDCCYY\nDDD1\n\rZCZCAY\nZCBCORR LENS\nZCCBRN\nZCDXYX\nZCEXYXYXYXYXYXYXY\nZCFXY1XY1XY1XY1XY1XY1XYXYXYXYXYXYXY\n\r\r\n',
  "ny": '@\n\x1e\rANSI 636001070002DL00410392ZN04330047DLDCANONE  \nDCBNONE        \nDCDNONE \nDBA08312013\nDCSMichael                                 \nDACM                                       \nDADMotorist                                \nDBD08312013\nDBB08312013\nDBC1\nDAYBRO\nDAU064 in\nDAG2345 ANYWHERE STREET               \nDAIYOUR CITY           \nDAJNY\nDAK123450000  \nDAQNONE                     \nDCFNONE                     \nDCGUSA\nDDEN\nDDFN\nDDGN\n\rZNZNAMDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5\n\r\r\n',
  "md_aamva": '@\n\x1e\rAAMVA6360030101DL00290192DLDAQK-134-123-145-103\nDAAJOHNSON,JACK,,3RD\nDAG1234 BARNEYS INN PL\nDAIBALTIMORE\nDAJMD\nDAK21230 \nDARC \nDAS \nDAT \nDAU505\nDAW135\nDBA20170209\nDBB19910209\nDBC1\nDBD20120210\nDBHN\r',
  "sc": '@\n\x1c\rANSI 6360050101DL00300201DLDAQ102245737\nDAASAMPLE,DRIVER,CREDENTIAL,\nDAG1500 PARK ST\nDAICOLUMBIA\nDAJSC\nDAK292012731  \nDARD   \nDAS          \nDAT     \nDAU600\nDAW200\nDAY   \nDAZ   \nDBA20190928\nDBB19780928\nDBC1\nDBD20091026\nDBG2\nDBH1\r\r\n',
  "oh": "@\n\x1e\rANSI 636023080102DL00410280ZO03210024DLDBA05262020\nDCSLASTNAME\nDACFIRSTNAME\nDADW\nDBD05132016\nDBB05261991\nDBC1\nDAYBLU\nDAU072 IN\nDAG5115 TEST DR\nDAIPENNSITUCKY\nDAJOH\nDAK606061337  \nDAQTG834904\nDCF2520UQ7248040000\nDCGUSA\nDDEN\nDDFN\nDDGN\nDAZBRO\nDCIUS,CALIFORNIA\nDCJNONE\nDCUNONE\nDCE4\nDDAM\nDDB12042013\nDAW170\nDDK1\nDCAD\nDCBB\nDCDNONE\rZOZOAY\nZOBY\nZOE05262020\r",
  "oh_missing_record_separator": "@\n\rANSI 636023080102DL00410280ZO03210024DLDBA05262020\nDCSLASTNAME\nDACFIRSTNAME\nDADW\nDBD05132016\nDBB05261991\nDBC1\nDAYBLU\nDAU072 IN\nDAG5115 TEST DR\nDAIPENNSITUCKY\nDAJOH\nDAK606061337  \nDAQTG834904\nDCF2520UQ7248040000\nDCGUSA\nDDEN\nDDFN\nDDGN\nDAZBRO\nDCIUS,CALIFORNIA\nDCJNONE\nDCUNONE\nDCE4\nDDAM\nDDB12042013\nDAW170\nDDK1\nDCAD\nDCBB\nDCDNONE\rZOZOAY\nZOBY\nZOE05262020\r",
};

// faked data or data from jurisdictional authorities
var magstripe = {
  "tx": '%TXAUSTIN^DOE\$JOHN^12345 SHERBOURNE ST^?;63601538774194=150819810101?#" 78729      C               1505130BLKBLK?',
  "fl": '%FLDELRAY BEACH^DOE\$JOHN\$^4818 S FEDERAL BLVD^           ?;6360100462172082009=2101198701010=?#! 33435      I               1600                                   ECCECC00000?',
  "fl2": '%FLDELRAY BEACH^JURKOV\$ROMAN\$^4818 N CLASSICAL BLVD^                            ?;6360100462172082009=2101198701010=?#! 33435      I               1600                                   ECCECC00000',
  "bc": '%BCKELOWNA^WILLY,\$MARVIN NERVON^1763 FAKE RD\$KELOWNA BC  V1Y 2P6^?;6360287290172=250619920101=?_%0AV1Y2P6                     M191100BRNGRN                           <*,A.9O1H8?'
};


void main() {
  AAMVAParser parser = AAMVAParser();
  test('Should throw Unimplemented for unsupported versions', () {

    expect(() => parser.decode(pdf417['oh']), throwsA(TypeMatcher<FormatException>()));
    expect(() => parser.decode(pdf417['aamva_v1']), throwsA(TypeMatcher<FormatException>()));
    expect(() => parser.decode(pdf417['aamva_v2']), throwsA(TypeMatcher<FormatException>()));
    expect(() => parser.decode(pdf417['ga']), throwsA(TypeMatcher<FormatException>()));
    expect(() => parser.decode(pdf417['indiana']), throwsA(TypeMatcher<FormatException>()));
    expect(() => parser.decode(pdf417['ca']), throwsA(TypeMatcher<FormatException>()));
    expect(() => parser.decode(pdf417['ny']), throwsA(TypeMatcher<FormatException>()));
    expect(() => parser.decode(pdf417['sc']), throwsA(TypeMatcher<FormatException>()));

  });

  test('Should throw FormatException when missing record separator', () {
    expect(() => parser.decode(pdf417['oh_missing_record_separator'], format: Format.PDF417), throwsA(TypeMatcher<FormatException>()));
  });

  test('Should scan a valid BC DL', () {

    var licenseData = magstripe['bc'];
    var cust = parser.decode(licenseData, format: Format.MAG);

    expect(cust, isNotNull);
    expect(cust.city, "KELOWNA");
    expect(cust.state, "BC");
    expect(cust.firstName, "MARVIN");
    expect(cust.middleName, "NERVON");
    expect(cust.lastName, "WILLY");
    expect(cust.postal, "V1Y2P6");
    expect(cust.licenseNumber, "7290172");
    expect(cust.address[0], "1763 FAKE RD");
    expect(cust.dob, DateTime(1992, 1, 1));
    expect(cust.expiry, DateTime(2025, 6, 30));
    expect(cust.height, Height(191, HeightUnit.CM));
    expect(cust.weight, Weight(100, WeightUnit.KG));
    expect(cust.eyes, "GRN");
    expect(cust.hair, "BRN");
    expect(cust.sex, Sex.MALE);
    expect(cust.endorsements, "");
    expect(cust.issueIdentifier, "636028");
    expect(cust.restrictions, "");
    expect(cust.prefix, isNull);
    expect(cust.suffix, isNull);

  });

  test("Should scan a wa edl", () {

    var licenseData = pdf417['wa_edl'];
    var cust = parser.decode(licenseData, format: Format.PDF417);

    // expect(cust.document?, 'OREALDD521DSL1083014J1459')
    expect(cust.issueIdentifier, '636045');
    expect(cust.address[0], '2600 MARTIN WAY');
    expect(cust.city, 'OLYMPIA');
    expect(cust.licenseClass ,'NONE');
    expect(cust.dob, DateTime(1948, 3, 10));
    expect(cust.endorsements, 'NONE');
    expect(cust.eyes, 'BLU');
    expect(cust.firstName, 'DABE');
    expect(cust.middleName, 'DEE');
    expect(cust.lastName, 'O REALTEST');
    expect(cust.prefix, isNull);
    expect(cust.hair, isNull);
    expect(cust.height, Height(70, HeightUnit.IN));
    expect(cust.expiry, DateTime(2013, 3, 10));
    expect(cust.issueDate, DateTime(2008, 10, 27));
    expect(cust.licenseNumber, 'OREALDD521DS');
    expect(cust.restrictions, 'NONE');
    expect(cust.sex, Sex.MALE);
    expect(cust.state, 'WA');
    expect(cust.suffix, 'V');
    expect(cust.weight, Weight(175, WeightUnit.LBS));

  });

  test("Should scan a valid FL DL", () {
    AAMVAParser parser = AAMVAParser();
    var licenseData = magstripe['fl'];
    var dl = parser.decode(licenseData, format: Format.MAG);
    expect(dl.firstName, 'JOHN');
    expect(dl.lastName, 'DOE');
    expect(dl.city, 'DELRAY BEACH');
    expect(dl.issueIdentifier, '636010');
    expect(dl.dob, DateTime(1987, 1, 1));
    expect(dl.expiry, DateTime(2021, 1, 31));
  });

  test("Should scan a valid TX DL", () {
    AAMVAParser parser = AAMVAParser();
    var licenseData = magstripe['tx'];
    var dl = parser.decode(licenseData, format: Format.MAG);
    expect(dl.firstName, 'JOHN');
    expect(dl.lastName, 'DOE');
    expect(dl.city, 'AUSTIN');
    expect(dl.issueIdentifier, '636015');
    expect(dl.dob, DateTime(1981, 1, 1));
    expect(dl.expiry, DateTime(2015, 8, 31));
  });

  test("Should scan a valid FL DL 2", () {
    AAMVAParser parser = AAMVAParser();
    var licenseData = magstripe['fl2'];
    var dl = parser.decode(licenseData, format: Format.MAG);
    expect(dl.firstName, 'ROMAN');
    expect(dl.lastName, 'JURKOV');
    expect(dl.state, 'FL');
    expect(dl.address[0], "4818 N CLASSICAL BLVD");
    expect(dl.city, 'DELRAY BEACH');
    expect(dl.issueIdentifier, '636010');
    expect(dl.dob, DateTime(1987, 1, 1));
    expect(dl.expiry, DateTime(2021, 1, 31));
  });

  test("Should scan a valid ON DL", () {
    var on = '''@\n\rANSI 636012030001DL00000367DLDCAG   \nDCBX         \nDCDNONE \nDBA20170914\nDCSPIECES,                                 \nDCTREESES,K                                                                        \nDBD20120524\nDBB19410714\nDBC1\nDAYNONE\nDAU150 cm\nDAG9206-12 FAKEDVILLE AVE,            \nDAITORONTO             \nDAJON\nDAKM6S 3B1    \nDAQP3291-52723-10723\nDCFCH3271654\nDCGCAN\nDCHNONE\nDCK*3312921*''';
    var parser = AAMVAParser();
    var dl = parser.decode(on);

    expect(dl, isNotNull);
    expect(dl.country, "CAN");
    expect(dl.firstName, "REESES");
    expect(dl.lastName, "PIECES");
    expect(dl.city, 'TORONTO');
    expect(dl.height, Height(150, HeightUnit.CM));
    expect(dl.weight, isNull);
    expect(dl.country, 'CAN');
    expect(dl.middleName, 'K');
    expect(dl.address[0], '9206-12 FAKEDVILLE AVE,');
    expect(dl.postal, 'M6S 3B1');
    expect(dl.state, 'ON');
    expect(dl.dob, new DateTime(1941, 7, 14));
    expect(dl.licenseNumber, 'P3291-52723-10723');
    expect(dl.issueIdentifier, '636012');
    expect(dl.cardType, CardType.DL);
    expect(dl.expiry, new DateTime(2017, 9, 14));
    expect(dl.issueDate, new DateTime(2012, 5, 24));
  });

  test("Should scan a v9 ON License ", () {
  String testData = '''@\n\rANSI 636012090002DL00410219ZO02600055DLDCAG\nDCB\nDCD\nDBA20251201\nDCSARR\nDACJAMES\nDADD\nDBD20201006\nDBB19811201\nDBC1\nDAYUNK\nDAU170 cm\nDAG333-19 FAKEVIEW ROAD\nDAIFAKECITYY\nDAJON\nDAKM5V3R7     \nDAQD32482252811201\nDCFGT9632237\nDCGCAN\nDDEN\nDDFN\nDDGN\nDCK*7581030*\nZOZOAARR,JAMES,D\nZOBY\nZOC\nZOD\nZOE\nZOZD2158-62528-11201\r''';
  var parser = AAMVAParser();
  var dl = parser.decode(testData);

  expect(dl, isNotNull);
  expect(dl.firstName, "JAMES");
  expect(dl.lastName, "ARR");
  expect(dl.middleName, "D");
  expect(dl.address[0], "333-19 FAKEVIEW ROAD");
  expect(dl.city, "FAKECITYY");
  expect(dl.state, "ON");
  expect(dl.postal, "M5V3R7");
  expect(dl.expiry, DateTime(2025, 12, 01));
  expect(dl.dob, DateTime(1981, 12, 01));
  expect(dl.licenseNumber, "D32482252811201");
  expect(dl.licenseClass, 'G');
  expect(dl.cardType, CardType.DL);
  expect(dl.restrictions, isNull);
  expect(dl.height, Height(170, HeightUnit.CM));
  expect(dl.issueDate, DateTime(2020, 10, 06));
  expect(dl.endorsements, isNull);

});

  test('test silly DateTime trick', () {
    var d = DateTime(2020, 13, 1).add(Duration(days: -1));
    expect(d.day, 31);
    expect(d.month, 12);
    expect(d.year, 2020);

    d = DateTime(2021, 03, 1).add(Duration(days: -1));
    expect(d.year, 2021);
    expect(d.month, 2);
    expect(d.day, 28);

  });




}
