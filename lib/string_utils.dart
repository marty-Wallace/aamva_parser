
String trim(String s, String c) {
  while(s.startsWith(c)) {
    s = s.replaceFirst(c, "");
  }
  while(s.endsWith(c)) {
    s = s.substring(0, s.length - c.length);
  }
  return s;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
