extension NullEmptyValidator on Object? {
  bool get isNull => this == null;

  bool get isNotNull => this != null;

  bool get isNullOrEmpty {
    final o = this;
    return o.isNull ||
        o.isStringObjectEmpty ||
        o.isIterableObjectEmpty ||
        o.isIterableObjectContainsNull ||
        o.isMapObjectEmpty;
  }

  bool get isNotNullOrEmpty {
    return !isNullOrEmpty;
  }

  bool get isStringObjectEmpty =>
      // ignore: avoid_bool_literals_in_conditional_expressions, cast_nullable_to_non_nullable
      (this is String) ? (this as String).isEmpty : false;

  bool get isIterableObjectEmpty =>
      // ignore: avoid_bool_literals_in_conditional_expressions, cast_nullable_to_non_nullable
      (this is Iterable) ? (this as Iterable).isEmpty : false;

  bool get isIterableObjectContainsNull =>
      // ignore: avoid_bool_literals_in_conditional_expressions, cast_nullable_to_non_nullable
      (this is Iterable) ? (this as Iterable).contains(null) : false;

  bool get isMapObjectEmpty =>
      // ignore: avoid_bool_literals_in_conditional_expressions, cast_nullable_to_non_nullable
      (this is Map) ? (this as Map).isEmpty : false;
}
