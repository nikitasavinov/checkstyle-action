package com.example;

import java.util.*;

final class badly_named_application<bad_class_type> {
  private static final int bad_constant = 1;
  private int BadField;

  String normalizeValue(String value) {
    return value.trim();
  }

  <bad_method_type> void Bad_Method(int Bad_parameter) {
    int BadLocal = bad_constant + BadField + Bad_parameter;
    List<String> values = List.of(String.valueOf(BadLocal));
    java.util.function.Consumer<String> consumer =
        (BadLambda) -> System.out.println(BadLambda);
    consumer.accept(values.get(0));
  }

  boolean hasValues(List<String> values) {
    return !values.isEmpty();
  }

  String firstValue(List<String> values) {
    return values.get(0);
  }

  void printValue(String value) {
    System.out.println(value);
  }

  void more_boken_stuff_here() {
  }
}
