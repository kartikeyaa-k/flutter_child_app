extension StringModifier on Map<String, String> {
  String? getValueFromQueryKey(String key) {
    return this[key];
  }
}
