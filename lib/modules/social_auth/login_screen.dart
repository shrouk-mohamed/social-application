import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/modules/social_layout/social_layout.dart';
import 'package:untitled3/shared/network_local/cache_helper.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit_auth/login-states.dart';
import '../../shared/cubit/cubit_auth/login_cubit.dart';
import '../register_screen/register_screen.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state){
          if(state is LoginErrorState){
            showToast(text: state.error,
                state: ToastState.ERORR);
          }
          if(state is LoginSuccessState){
            CacheHelper.saveData(
              key: 'uId',
                value: state.uId,
            ).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context,state){
          return  Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
                            style:
                            Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Login now to communicate with friends",
                            style:
                            Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.grey,
                              fontSize: 23,
                            ),
                          ),
                          const SizedBox(height: 20),
                          deffaultFormField(
                            controller: emailController,
                            labelText: "Email Address",
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Email must not be empty";
                              }
                            },
                            prefix: Icons.email_outlined,
                          ),
                          const SizedBox(height: 15),
                          deffaultFormField(
                            controller: passwordController,
                            isPassword: LoginCubit.get(context).isbassword,
                            labelText: "Password",
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Password is too short';
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            prefix: Icons.lock,
                            suffix: LoginCubit.get(context).suffex,
                            suffixPressed: () {
                              LoginCubit.get(context)
                                  .changePaasswordVisibility();
                            },
                          ),
                          const SizedBox(height: 15),
                          BuildCondition(
                            condition: state is! LoginLoadingState,
                            builder: (context) => deffaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: "login",
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              deffaultTextButton(
                                onPressed: () {
                                  navigateTo(
                                    context,
                                    RegisterScreen(),
                                  );
                                },
                                text: "regester",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );

  }
}
