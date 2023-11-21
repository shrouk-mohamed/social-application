abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  // final RegisterModel regesterModel;
  // RegisterSuccessState(this.regesterModel);
}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);

}

class RegisterCreateUserSuccessState extends RegisterStates {}

class RegisterCreateUserErrorState extends RegisterStates {
  final String error;

  RegisterCreateUserErrorState(this.error);

}

class RegisterChangePasswordVisibilityState extends RegisterStates {}