


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nike_store_flutter/data/local/shared.dart';
import 'package:nike_store_flutter/data/models/auth.dart';
import 'package:nike_store_flutter/data/repo/auth_repo.dart';
import 'package:nike_store_flutter/data/repo/cart_repo.dart';
import 'package:nike_store_flutter/gen/assets.gen.dart';
import 'package:nike_store_flutter/ui/auth/auth.dart';
import 'package:nike_store_flutter/ui/favorite/favorite.dart';
import 'package:nike_store_flutter/ui/history/history.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onTapChangeThem});
  final Function(bool isLightMode) onTapChangeThem;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


bool isLogin=LocalData.getToken().token.isNotEmpty;
ValueNotifier<AuthEntity>? valueNotifier;
bool isLightMode = true;



  

@override
  void initState() {

    valueNotifier=AuthRepositoryImpl.valueNotifier
    ..addListener(() {
      String token = LocalData.getToken().token;
     bool log = LocalData.lightModeStatus;
      setState(() {
         if(token.isNotEmpty){
        isLogin = true;
      }else{
        isLogin = false;
      }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('پروفایل'),
        actions: [
          Center(child: Text('تغییر تم برنامه' , style: theme.textTheme.bodyText2,)),
          Switch(
            activeThumbImage: Assets.images.sun.provider(),
            inactiveThumbImage: Assets.images.moon.provider(),
            inactiveThumbColor:Colors.blue.shade900 ,
            inactiveTrackColor: Colors.blue.shade100,
            activeTrackColor: Colors.black12,
            thumbColor:  MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.black38;
    }
    return Colors.blue.shade900 ;
  }),

            onChanged: (value) {
              widget.onTapChangeThem(value);
              
              setState(() {
                isLightMode = value;
                LocalData.setthemeColor(value);
              });
            },
            value:LocalData.lightModeStatus,
          )
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
          Container(width: 100,height: 100,padding: const EdgeInsets.all(8),decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),border: Border.all(color: Colors.grey,width: 1.5)),
            child: Assets.images.nikeLogo.image(width: 48,height: 48,fit: BoxFit.contain,color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 8,),
          Text(LocalData.userName.isEmpty ? 'کاربرمهمان': LocalData.userName,style: theme.textTheme.bodyText2,),
          const SizedBox(height: 56,),
          ListTile(onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoriteScreen(),));
          },leading: const Icon(CupertinoIcons.heart), title: Text('لیست علاقه مندی ها',style: theme.textTheme.bodyText2 ,)),
          const Divider(),
          ListTile(onTap: (() => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const HistoryScreen(),))),leading: const Icon(CupertinoIcons.shopping_cart), title: Text('سوابق خرید',style: theme.textTheme.bodyText2),),
          const Divider(),
          ListTile(onTap: (){

            
            setState(() {
              if(isLogin){
                   showDialog(context: context,barrierDismissible: false, builder: (context) {
              return AlertDialog(

                title: Text('خروج از جساب کاربری' , style: theme.textTheme.headline6,),
                content: Text('ایا میخواهید از حسابتان خارج شوید؟',style: theme.textTheme.bodyText2,),
                actions: [
                  TextButton(child: Text('خیر'), onPressed: (){
                      Navigator.of(context).pop();
                },),
                TextButton(child: Text('بله'), onPressed: (){
                       authRepository.logout();
                       Navigator.of(context).pop();
                       setState(() {
                         widget.onTapChangeThem(isLogin? LocalData.lightModeStatus : true);
                       });
                       
                      
                },),
                
              ],);
            },);
              }else{
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) {
                  return const AuthScreen();
                },));
              }
              
            });
          },leading: Icon(isLogin? Icons.exit_to_app : Icons.login), title: Text(isLogin? 'خروج از حساب کاربری':'ورود به حساب کاربری',style: theme.textTheme.bodyText2),),
      ],),
    );
  }
}