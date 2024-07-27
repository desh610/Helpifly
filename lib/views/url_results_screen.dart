import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/url_results_bloc/url_results_cubit.dart';
import 'package:helpifly/bloc/url_results_bloc/url_results_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/widgets/custom_textfield.dart';
import 'package:helpifly/widgets/custom_button.dart';
import 'package:helpifly/widgets/skeletons.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class UrlResultsScreen extends StatelessWidget {
  UrlResultsScreen({super.key});

  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
              SizedBox(height: 0),
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
                  if (state.isLoading) {
                    return Skeletons(context: context)
                        .urlSearchResultSkeleton();
                  } else if (state.error != null) {
                    return Center(
                        child: Text(state.error!,
                            style: TextStyle(color: Colors.red)));
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Results",
                          style: TextStyle(
                              fontSize: 18,
                              color: white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        CustomPercentage(
                          title: "Positive",
                          percentage:
                              "${state.positivePercentage.toStringAsFixed(2)}%",
                          fillPercentage: state.positivePercentage,
                          fillColor: green,
                        ),
                        CustomPercentage(
                          title: "Negative",
                          percentage:
                              "${state.negativePercentage.toStringAsFixed(2)}%",
                          fillPercentage: state.negativePercentage,
                          fillColor: CupertinoColors.destructiveRed,
                        ),
                        CustomPercentage(
                          title: "Neutral",
                          percentage:
                              "${state.neutralPercentage.toStringAsFixed(2)}%",
                          fillPercentage: state.neutralPercentage,
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
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 90,
                              width: 90,
                              child: LiquidCircularProgressIndicator(
                                value: state.positivePercentage / 100,
                                valueColor: AlwaysStoppedAnimation(green),
                                backgroundColor: Colors.transparent,
                                borderColor: white.withOpacity(0.5),
                                borderWidth: 2,
                                direction: Axis.vertical,
                                center: Text(
                                  "${state.positivePercentage.toStringAsFixed(2)}%",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      
                        // ValueListenableBuilder(
                        //   valueListenable: _urlController,
                        //   builder: (context, _, __) {
                        //     return CustomButton(
                        //       onTap: () {
                        //         closeKeyboard(context);
                        //         context.read<UrlResultsCubit>().analyzeUrl(_urlController.text, context);
                        //       },
                        //       buttonText: "Check Quality",
                        //       enabled: _urlController.text.isNotEmpty && !state.isLoading,
                        //     );
                        //   },
                        // ),
                      ],
                    );
                  }
                },
              ),
              //  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              BlocBuilder<UrlResultsCubit, UrlResultsState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
                    child:  
                    ValueListenableBuilder(
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
                        ),
                  );
                },
              ),
              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}
