int? tryParseInt(String value) {
  try {
    return int.parse(value);
  } catch (e) {
    return null;
  }
}

double? tryParseDouble(String value) {
  try {
    return double.parse(value);
  } catch (e) {
    return null;
  }
}
