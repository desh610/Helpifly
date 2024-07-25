import 'package:flutter/foundation.dart';

class UrlResultsState {
  final double positivePercentage;
  final double negativePercentage;
  final double neutralPercentage;
  final bool isLoading;
  final String? error;

  UrlResultsState({
    this.positivePercentage = 0.0,
    this.negativePercentage = 0.0,
    this.neutralPercentage = 0.0,
    this.isLoading = false,
    this.error,
  });

  UrlResultsState copyWith({
    double? positivePercentage,
    double? negativePercentage,
    double? neutralPercentage,
    bool? isLoading,
    String? error,
  }) {
    return UrlResultsState(
      positivePercentage: positivePercentage ?? this.positivePercentage,
      negativePercentage: negativePercentage ?? this.negativePercentage,
      neutralPercentage: neutralPercentage ?? this.neutralPercentage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
