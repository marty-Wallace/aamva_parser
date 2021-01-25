import 'package:aamva_parser/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test trim a string", () {
    expect(trim(";test;", ";"), "test");
    expect(trim(";;;;;;test;;;;;;;", ";"), "test");
    expect(trim(";test", ";"), "test");
    expect(trim("test;", ";"), "test");
    expect(trim("test", ";"), "test");
  });
}
