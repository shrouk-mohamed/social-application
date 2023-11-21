import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/models/user_model.dart';
import 'package:untitled3/modules/chat_details/chat_details_screen.dart';
import 'package:untitled3/shared/components/components.dart';
import 'package:untitled3/shared/cubit/cubit.dart';
import 'package:untitled3/shared/cubit/states.dart';

import '../../shared/styles/colors.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialAppStates>(
      listener: (context,state){},
      builder: (context,state){
        return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index) => buildChatItem(SocialCubit.get(context).users[index],context),
            separatorBuilder: (context,index) => myDivider(),
            itemCount: SocialCubit.get(context).users.length,
          );
      },

    );
  }

  Widget buildChatItem(SocialUserModel model, context) =>  InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(
        userModel: model,
      ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:   [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${model.image}',
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            '${model.name}',
            style: const TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}
