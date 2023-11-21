import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/models/message_model.dart';
import 'package:untitled3/models/user_model.dart';
import 'package:untitled3/shared/cubit/cubit.dart';
import 'package:untitled3/shared/cubit/states.dart';

import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
 SocialUserModel? userModel;
 ChatDetailsScreen({
   this.userModel,
});
 TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel!.uId!,);
        return BlocConsumer<SocialCubit,SocialAppStates>(
          listener: (context,state){
            if(state is SocialSendMessageSuccessState){
              messageController.clear();
            }
          },
          builder: (context,state){
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        '${userModel?.image}',
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '${userModel!.name}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding:
                EdgeInsets.all(20.0),
                child: Column(
                  children: [
                   Expanded(
                     child: ListView.separated(
                       physics: BouncingScrollPhysics(),
                         itemBuilder: (context,index){
                           var message = SocialCubit.get(context).message[index];
                           if(SocialCubit.get(context).userModel!.uId ==
                           message.senderId)
                             return buildMyMessage(message);

                           return buildMessage(message);
                         } ,
                         separatorBuilder: (context,index)=>const SizedBox(
                           height: 10.0,
                         ) ,
                         itemCount: SocialCubit.get(context).message.length,),
                   ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,

                        ),
                        borderRadius: BorderRadius.circular(15.0,),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here',

                                ),
                              )),
                          Container(
                            height: 50.0,
                            color: defaultColor,
                            child: MaterialButton(
                              onPressed: (){
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userModel!.uId!,
                                  dateTime:DateTime.now().toString(),
                                  text:messageController.text ,
                                );
                              },
                              minWidth: 1.0,
                              child: Icon(
                                IconBroken.Send,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

        );
      },
    );
  }
  Widget buildMessage( MessageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(

      decoration:  BoxDecoration(
        color:  Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(10.0,),
          topStart: Radius.circular(10.0,),
          topEnd: Radius.circular(10.0,),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        '${model.text}',
      ),
    ),
  );
 Widget buildMyMessage( MessageModel model) =>  Align(
   alignment: AlignmentDirectional.centerEnd,
   child: Container(

     decoration:  BoxDecoration(
       color: defaultColor.withOpacity(.2,),
       borderRadius: const BorderRadiusDirectional.only(
         bottomStart: Radius.circular(10.0,),
         topStart: Radius.circular(10.0,),
         topEnd: Radius.circular(10.0,),
       ),
     ),
     padding: EdgeInsets.symmetric(
       vertical: 5.0,
       horizontal: 10.0,
     ),
     child: Text(
       '${model.text}',
     ),
   ),
 );
}
