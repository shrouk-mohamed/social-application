import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/shared/cubit/cubit_auth/register_states.dart';

import '../../../models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isbassword = true;
  IconData suffex = Icons.visibility_off_outlined;
  void changePaasswordVisibility() {
    isbassword = !isbassword;
    suffex =
    isbassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
        isEmailVerified: false,
      );
      print(value.user?.email);
      print(value.user?.uid);

      //emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
    String? image,
    String? cover,
    String? bio,
    required bool isEmailVerified,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: 'https://img.freepik.com/free-photo/satisfied-pleased-young-woman-promots-product-gives-recommendation-stands-with-broad-smile-against-yellow-wall-take-look-there-european-female-turns-your-attention-banner_273609-42884.jpg?w=2000',
      cover: 'https://img.freepik.com/free-photo/satisfied-pleased-young-woman-promots-product-gives-recommendation-stands-with-broad-smile-against-yellow-wall-take-look-there-european-female-turns-your-attention-banner_273609-42884.jpg?w=2000',
      bio: 'write your bio ...',
      isEmailVerified: false,
    );

   FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap(),
    ).then((value) {
      emit(RegisterCreateUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(RegisterCreateUserErrorState(error));
    });
  }
}



// SocialUserModel(
//   name = name,
//   email = email,
//   phone = phone,
//   uId = uId,
//   image = image,
//   //"https://image.freepik.com/free-photo/old-wooden-texture-background-vintage_55716-1138.jpg?w=740",
//   cover = cover,
//   //"https://image.freepik.com/free-photo/islamic-new-year-pattern-background_23-2148950279.jpg?w=740",
//   bio = bio,
//   //"Weite your bio",
//   isEmailVerified = isEmailVerified,
// );