enum Sex { MALE, FEMALE, UNSPECIFIED }

Sex sexFromString(String sex) {
  if (sex == 'M') {
    return Sex.MALE;
  }
  if (sex == 'F') {
    return Sex.FEMALE;
  }
  if (sex == '1') {
    return Sex.MALE;
  }
  if (sex == '2') {
    return Sex.FEMALE;
  }
  return Sex.UNSPECIFIED;
}
