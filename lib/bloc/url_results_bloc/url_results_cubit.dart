import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/url_results_bloc/url_results_state.dart';
import 'package:helpifly/widgets/screen_loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UrlResultsCubit extends Cubit<UrlResultsState> {
  UrlResultsCubit() : super(UrlResultsState());

  Future<void> analyzeUrl(String url, BuildContext context) async {
    // Loading().startLoading(context);
    emit(state.copyWith(isLoading: true));
    try {
      final response = await analyzeURLBE(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final positivePercentage = (data['positive_count'] / (data['positive_count'] + data['negative_count'] + data['neutral_count'])) * 100;
        final negativePercentage = (data['negative_count'] / (data['positive_count'] + data['negative_count'] + data['neutral_count'])) * 100;
        final neutralPercentage = (data['neutral_count'] / (data['positive_count'] + data['negative_count'] + data['neutral_count'])) * 100;

        emit(state.copyWith(
          positivePercentage: positivePercentage,
          negativePercentage: negativePercentage,
          neutralPercentage: neutralPercentage,
          isLoading: false,
        ));
        // Loading().stopLoading(context);
      } else {
        // Loading().stopLoading(context);
        emit(state.copyWith(
          isLoading: false,
          error: "Failed to load results.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "An error occurred: $e",
      ));
    }
  }

  Future<http.Response> analyzeURLBE(String urlString) async {
    var url = Uri.parse('https://deshan96.pythonanywhere.com/url-analyze');
    // var url = Uri.parse('http://10.0.2.2:5000/url-analyze');
    // Use the following line for local testing:
    // var url = Uri.parse('http://127.0.0.1:5000/predict');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"url": urlString}), // Use urlString instead of url
      );

      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        print('Failed to load. Status code: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  reset(){
     emit(state.copyWith(
          positivePercentage: 0.0,
          negativePercentage: 0.0,
          neutralPercentage: 0.0,
          isLoading: false,
        ));
  }
}
