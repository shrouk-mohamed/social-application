import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/modules/new_post/new_post_screen.dart';
import 'package:untitled3/shared/components/components.dart';
import 'package:untitled3/shared/cubit/cubit.dart';
import 'package:untitled3/shared/cubit/states.dart';

import '../../shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialAppStates>(
      listener: (context,state){
        if(state is SocialNewPostState){
          navigateTo(context, NewPostScreen(),);
        }
      },
      builder: (context,state){
        var cubit = SocialCubit.get(context);

        return  Scaffold(
          appBar: AppBar(
            title:  Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(
                    IconBroken.Notification,
                  ),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(
                  IconBroken.Search,
                ),
              ),

            ],
          ),
          body:cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.Home,
                  ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Paper_Upload,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Location,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
