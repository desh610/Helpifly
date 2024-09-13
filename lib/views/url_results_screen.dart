import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/url_results_bloc/url_results_cubit.dart';
import 'package:helpifly/bloc/url_results_bloc/url_results_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/widgets/custom_textfield.dart';
import 'package:helpifly/widgets/custom_button.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class UrlResultsScreen extends StatelessWidget {
  UrlResultsScreen({super.key});

  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: GestureDetector(
          onTap: () {
            closeKeyboard(context); // Close the keyboard when tapping outside
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Check product quality\nby URL",
                  style: TextStyle(
                    color: white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _urlController,
                  hintText: "Enter product URL here",
                  overlineText: "Product URL",
                  minLines: 5,
                  maxLines: 5,
                  buttonText: "Clear",
                  onTapTextButton: () {
                    _urlController.clear();
                    context.read<UrlResultsCubit>().reset();
                  },
                ),
                SizedBox(height: 15),
                BlocBuilder<UrlResultsCubit, UrlResultsState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Results",
                          style: TextStyle(
                            fontSize: 18,
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        CustomPercentage(
                          title: "Positive",
                          percentage: state.isLoading ? "..." : "${state.positivePercentage.toStringAsFixed(2)}%",
                          fillPercentage: state.isLoading ? 0 : state.positivePercentage,
                          fillColor: green,
                        ),
                        CustomPercentage(
                          title: "Negative",
                          percentage: state.isLoading ? "..." : "${state.negativePercentage.toStringAsFixed(2)}%",
                          fillPercentage: state.isLoading ? 0 : state.negativePercentage,
                          fillColor: red,
                        ),
                        CustomPercentage(
                          title: "Neutral",
                          percentage: state.isLoading ? "..." : "${state.neutralPercentage.toStringAsFixed(2)}%",
                          fillPercentage: state.isLoading ? 0 : state.neutralPercentage,
                          fillColor: CupertinoColors.activeOrange,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Overall Product Quality",
                              style: TextStyle(
                                fontSize: 18,
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 90,
                              width: 90,
                              child: LiquidCircularProgressIndicator(
                                value: state.isLoading ? 0 : state.positivePercentage / 100,
                                valueColor: AlwaysStoppedAnimation(green),
                                backgroundColor: Colors.transparent,
                                borderColor: white.withOpacity(0.5),
                                borderWidth: 2,
                                direction: Axis.vertical,
                                center: Text(
                                  state.isLoading ? "..." : "${state.positivePercentage.toStringAsFixed(2)}%",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Spacer(),
                BlocBuilder<UrlResultsCubit, UrlResultsState>(
                  builder: (context, state) {
                    return ValueListenableBuilder(
                      valueListenable: _urlController,
                      builder: (context, _, __) {
                        return CustomButton(
                          onTap: () {
                            closeKeyboard(context);
                            context.read<UrlResultsCubit>().analyzeUrl(_urlController.text, context);
                          },
                          buttonText: "Check Quality",
                          enabled: _urlController.text.isNotEmpty && !state.isLoading,
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
