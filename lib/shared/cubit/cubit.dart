
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled3/models/message_model.dart';
import 'package:untitled3/models/post_model.dart';
import 'package:untitled3/models/user_model.dart';
import 'package:untitled3/modules/chats/chat_screen.dart';
import 'package:untitled3/modules/feeds/feeds_screen.dart';
import 'package:untitled3/modules/new_post/new_post_screen.dart';
import 'package:untitled3/modules/settings/settings_screen.dart';
import 'package:untitled3/modules/users/users_screen.dart';
import 'package:untitled3/shared/components/constants.dart';
import 'package:untitled3/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/comment_model.dart';

class SocialCubit extends Cubit<SocialAppStates> {
  SocialCubit() : super(SocialAppInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];
  List<String> titles = [
    "News Feed",
    "Chats",
    "Create Post",
    "Account",
    "Settings",
  ];
  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialAppLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel =
          SocialUserModel.fromJson(value.data() as Map<String, dynamic>);
      emit(SocialAppSucsesslState());
    }).catchError((erorr) {
      emit(SocialAppErorrState(erorr));
    });
  }


  void changeBottomNav(int index) {
    if( index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavigationBarItemsState());
    }
  }

  final ImagePicker picker = ImagePicker();
  XFile? coverImage;
  File? coverImageFile;

  Future<void> getCoverImage() async {
    coverImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (coverImage != null) {
      coverImageFile = File(coverImage!.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print("please selected image");
      emit(SocialCoverImagePickedErorrState());
    }
  }

  XFile? profileImage;
  File? profileImageFile;

  Future<void> getProfileImage() async {
    profileImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (profileImage != null) {
      profileImageFile = File(profileImage!.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print("please selected image");
      emit(SocialProfileImagePickedErorrState());
    }
  }


  String profileImageUrl = "";

  void uploadProfileImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) async {
    emit(SocialUserImagesUpdateloadingStates());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImageFile!) //image waslet el storage
        .then((value) {
      value.ref.getDownloadURL().then(
            (value) {
          profileImageUrl = value;
          updateUser(
            name: name,
            phone: phone,
            bio: bio,
            image: value,
          );
          emit(SocialUploadImageProfileSuccessStates());
        },
      ).catchError(
            (error) {
          emit(SocialUploadImageProfileErorrStates());
        },
      );
    }).catchError(
          (error) {
        print(error.toString());
        emit(SocialUploadImageProfileErorrStates());
      },
    );
  }

  String coverImageUrl = "";

  void uplodCoverImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) async {
    emit(SocialUserImagesUpdateloadingStates());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImageFile!) //image waslet el storage
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
        emit(SocialUploadImageCoverSuccessStates());
      }).catchError((erorr) {
        print(erorr);
        emit(SocialUploadImageCoverErorrStates());
      });
    }).catchError((erorr) {
      print(erorr);
      emit(SocialUploadImageCoverErorrStates());
    });
  }


  void updateUser({
    required String? name,
    required String? phone,
    required String? bio,
    String? cover,
    String? image,
  }) {
    emit(SocialUpdateUserloadingStates());
    SocialUserModel socialUserModel = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      uId: uId,
      email: userModel!.email,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(socialUserModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((erorr) {
      print(erorr);
      emit(SocialUserUpdateErorrStates());
    });
  }


  XFile? postImage;
  File? postImageFile;

  Future<void> getPostImage() async {
    postImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (postImage != null) {
      postImageFile = File(postImage!.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print("please selected image");
      emit(SocialPostImagePickedErorrState());
    }
  }

  void uploadPostImage({
    required String? dateTime,
    required String? text,
  }) {
    emit(SocialCreatePostLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}")
        .putFile(postImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        emit(SocialUploadPostImageSuccessStates());
      }).catchError((erorr) {
        emit(SocialUploadPostImageErorrStates());
      });
    }).catchError((erorr) {
      emit(SocialUploadPostImageErorrStates());
    });
  }


  void createPost({
    required String? dateTime,
    required String? text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingStates());
    PostModel postModel = PostModel(
      image: userModel!.image,
      name: userModel!.name,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection("posts")
        .add(postModel.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessStates());
    }).catchError((erorr) {
      emit(SocialCreatePostErorrStates());
    });
  }


  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageStates());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  PostModel? post_model;

  void getPosts() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostsSucsessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErorrState(error.toString()));
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like':true,
    }).then((value) {
      emit(SocialPostLikesSucsessState());
    }).catchError((erorr){
      emit(SocialPostLikesErorrState(erorr.toString()));
    });
  }

  XFile? commentImage;
  File? commentImageFile;
  Future<void> getCommentImage() async{
    coverImage = await picker.pickImage(
        source: ImageSource.gallery,
    );
    if(commentImage != null){
      commentImageFile= File(commentImage!.path);
      emit(SocialCommentImagePickedSuccessState());
    }else {
      print('please selected image');
      emit(SocialCommentImagePickedErorrState());
    }
    }
    void uploadCommentImage({
  required String uidComment,
      required String textComment,
      String? postId,
}){
    emit(SocialCreatePostLoadingStates());
    firebase_storage.FirebaseStorage.instance
    .ref()
    .child('comments/${Uri.file(commentImage!.path).pathSegments.last}')
    .putFile(commentImageFile!)
    .then((value) {
      value.ref.getDownloadURL().then((value) {
        createComment(
          uidComment: uidComment,
          textComment: textComment,
          imageComment: value,
          postId: postId!,
        );
      }).catchError((erorr){emit(SocialUploadCommentImageErorrStates());
      });
    }).catchError((erorr){
      emit(SocialUploadCommentImageErorrStates());
    });
    }
  void createComment({
    required String uidComment,
    required String textComment,
    String? imageComment,
    String? postId,
  }) {
    emit(SocialCreateCommentLoadingStates());
    CommentModel commentModel = CommentModel(
      name: userModel!.name,
      textComment: textComment,
      image: userModel!.image,
      uId: userModel!.uId,
      imageComment: imageComment,
      postId: postId,
    );
    FirebaseFirestore.instance
        .collection("posts")
        .doc(uidComment)
        .collection("comments")
        .doc(userModel!.uId)
        .set(commentModel.toMap())
        .then((value) {
      emit(SocialCreateCommentSuccessStates());
    }).catchError((erorr) {
      emit(SocialCreateCommentErorrStates());
    });
  }
  List<CommentModel> commentsModel = [];
  List<String> postsIdComment = [];

  List<int> comments = [];
  void getComments() {
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
          postsIdComment.add(element.id);
          commentsModel.add(CommentModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetCommentsSuccsessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetCommentsErorrState(error.toString()));
    });
  }
  List<SocialUserModel> users = [];
   void getAllUsers(){
     emit(SocialGetAllUsersLoadingState());
     if(users.isEmpty){
       FirebaseFirestore.instance.collection('users').get().then((value) {
             value.docs.forEach((element) {
               if(element['uId'] != userModel!.uId){
                 users.add(SocialUserModel.fromJson(element.data()));
               }
               emit(SocialGetAllUsersSuccessState());
             });
       }).catchError((erorr){
         print(erorr.toString());
         emit(SocialGetAllUsersErorrState(erorr.toString()));
       });
     }
   }

   void sendMessage({
  required String receiverId,
     required String dateTime,
     required String text,
}){
     emit(SocialSendMessageLoadingState());
     MessageModel model = MessageModel(
       text: text,
       senderId: userModel!.uId,
       receiverId: receiverId,
       dateTime: dateTime,
     );
     FirebaseFirestore.instance
     .collection('users')
     .doc(userModel!.uId)
     .collection('chats')
     .doc(receiverId)
     .collection('messages')
     .add(model.toMap())
     .then((value) {
       emit(SocialSendMessageSuccessState());
     }).catchError((erorr){
       emit(SocialSendMessageErorrState(erorr));
     });

     //receiver message
     FirebaseFirestore.instance
         .collection('users')
         .doc(receiverId)
         .collection('chats')
         .doc(userModel!.uId)
         .collection('messages')
         .add(model.toMap())
         .then((value) {
       emit(SocialSendMessageSuccessState());
     }).catchError((erorr){
       emit(SocialSendMessageErorrState(erorr));
     });

   }
   List<MessageModel> message=[];
   void getMessages({
  required String receiverId,
}){
     FirebaseFirestore.instance
         .collection('users')
         .doc(userModel!.uId)
         .collection('chats')
         .doc(receiverId)
         .collection('messages')
         .orderBy('dateTime')
         .snapshots()
         .listen((event) {
           message = [];
           event.docs.forEach((element) {
             message.add(
               MessageModel.fromJson(element.data()),
             );
           });
           emit(SocialGetMessageSuccessState());
     });
   }
}
