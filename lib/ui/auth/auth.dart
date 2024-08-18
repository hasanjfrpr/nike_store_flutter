

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/repo/auth_repo.dart';
import 'package:nike_store_flutter/gen/assets.gen.dart';
import 'package:nike_store_flutter/ui/auth/bloc/auth_bloc.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class AuthScreen extends StatefulWidget {
   const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {



  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
   
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              onSurface: Colors.white
            ),
            snackBarTheme:theme.snackBarTheme.copyWith( 
              
              contentTextStyle: TextStyle(color: Colors.white)
            )
          ),
          child: Scaffold(
              backgroundColor: theme.colorScheme.secondary,
              body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 32),
            child: BlocProvider(
              create: (context) {
                final authBloc = AuthBloc(authRepository);
                authBloc.stream.forEach((state) {
                  if(state is AuthError){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.exception.toString()),backgroundColor: theme.colorScheme.primary,));
                  }else if(state is AuthSuccess){
                    Navigator.of(context).pop();
                  }
                });
                authBloc.add(AuthStarted());
                return authBloc;
              },
              child: BlocBuilder<AuthBloc,AuthState>(
                builder: (context, state) {
                  return 
                 Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
                  Assets.images.nikeLogo.image(color: theme.colorScheme.onSecondary,width: 120,),
                  Text('خوش آمدید',style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.onSecondary),),
                  const SizedBox(height: 8,),
                   Text(state.isLogin?'لطفا وارد حساب کاربری خود شوید':'لطفا برای ثبت نام اطلاعات زیر را تکمیل کنید'
                   ,style: theme.textTheme.bodyText1!.copyWith(color: theme.colorScheme.onSecondary),maxLines: 2,overflow: TextOverflow.clip,),
                  const SizedBox(height: 46,),
                 // CustomTextField(lable: 'ایمیل', textInputType: TextInputType.emailAddress,
                 // borderColor: theme.colorScheme.onSecondary,textEditingController: _userNameController,),
                 TextField(
        controller: _userNameController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
       disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
         labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color:Colors.white )
          ),
          label: const Text('ایمیل'),
        ),
      ),
                   const SizedBox(height: 8,),
                   _PassWordTextField(textEditingController: _passwordController,),
                   const SizedBox(height: 12,),
                   ElevatedButton(onPressed: (){
                    BlocProvider.of<AuthBloc>(context).add(AuthClicked(_userNameController.text, _passwordController.text));
                   },
                   child:state is AuthLoading?CircularProgressIndicator(color: theme.colorScheme.onPrimary,): Text(state.isLogin?'ورود':'ثبت نام',style: theme.textTheme.bodyText2!.copyWith(color: Colors.white)),
                   style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )),
                    minimumSize: MaterialStateProperty.all(const Size(double.infinity, 56))
                   ),
                   ),
                   const SizedBox(height: 8,),
                   GestureDetector(
                    onTap: (){
                       BlocProvider.of<AuthBloc>(context).add(ChangeStateLogin());
                    },
                     child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Text(state.isLogin?'حساب کاربری ندارید؟':'حساب کاربری دارم! ',style: theme.textTheme.bodyText2!.copyWith(color: Colors.white),),
                      const SizedBox(width: 4,),
                      Text(state.isLogin?'ثبت نام':'ورود',style: theme.textTheme.bodyText2!.copyWith(decoration: TextDecoration.underline,color: theme.colorScheme.primary),)
                     ],),
                   )
                ]);
              
                },),
            ),
          ),
              ),
            ),
        );
  }
}






class _PassWordTextField extends StatefulWidget{
  final TextEditingController textEditingController;

  const _PassWordTextField({super.key, required this.textEditingController});
  @override
  State<_PassWordTextField> createState() => _PassWordTextFieldState();
}

class _PassWordTextFieldState extends State<_PassWordTextField> {
 

  bool visible=true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: visible,
      decoration: InputDecoration(
        suffix: GestureDetector(onTap: (){
          setState(() {
            visible = !visible;
          });
        },child: Icon(!visible? Icons.visibility_outlined:Icons.visibility_off_outlined,color: Colors.white.withOpacity(0.5),)),
      labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color:Colors.white )
          ),
        label: const Text('رمز عبور'),
      ),
    );
  }
}