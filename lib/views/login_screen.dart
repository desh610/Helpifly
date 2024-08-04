import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/login_bloc/login_cubit.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/views/signup_screen.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(image: AssetImage('assets/images/login7.png'), fit: BoxFit.cover)
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Login here",
                          style: TextStyle(fontSize: 32, color: white, fontWeight: FontWeight.bold),
                        ),
                         SizedBox(height: 4),
                              Text(
                      "Explore your journey with Helpifly!",
                      style: TextStyle(fontSize: 14, color: white, fontWeight: FontWeight.w600, letterSpacing: 1.6),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                // Row(
                //   children: const [
                //     Text(
                //       "Login here",
                //       style: TextStyle(fontSize: 32, color: white, fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 4),
                // Row(
                //   children: const [
                //     Text(
                //       "Explore your journey with Helpifly!",
                //       style: TextStyle(fontSize: 14, color: grayColor, fontWeight: FontWeight.w400, letterSpacing: 1.6),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  overlineText: "Email",
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  overlineText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state.isLoading) {
                      // Show loading indicator if needed
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      onTap: () {
                        closeKeyboard(context);
                        context.read<LoginCubit>().login(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                      buttonText: "Login",
                    );
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: grayColor, fontSize: 14),
                        ),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(color: lightGrayColor, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
