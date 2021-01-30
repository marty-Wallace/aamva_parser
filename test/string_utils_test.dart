import 'package:aamva_parser/string_utils.dart';
import 'package:test/test.dart';

void main() {
  test("Test trim a string", () {
    expect(trim(";test;", ";"), "test");
    expect(trim(";;;;;;test;;;;;;;", ";"), "test");
    expect(trim(";test", ";"), "test");
    expect(trim("test;", ";"), "test");
    expect(trim("test", ";"), "test");
  });
}
