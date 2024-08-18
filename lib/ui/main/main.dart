import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nike_store_flutter/config_them.dart';
import 'package:nike_store_flutter/data/local/hive.dart';
import 'package:nike_store_flutter/data/local/shared.dart';
import 'package:nike_store_flutter/data/repo/banner_repo.dart';
import 'package:nike_store_flutter/data/repo/cart_repo.dart';
import 'package:nike_store_flutter/data/repo/product_repo.dart';
import 'package:nike_store_flutter/gen/assets.gen.dart';
import 'package:nike_store_flutter/ui/auth/auth.dart';
import 'package:nike_store_flutter/ui/cart/cart.dart';
import 'package:nike_store_flutter/ui/home/home.dart';
import 'package:nike_store_flutter/ui/profile/profile.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalData.getSharedInstance();
  await LocalHiveDataBase.genearatedHive();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


ThemeMode _themeMode = LocalData.lightModeStatus ? ThemeMode.light : ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const[
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        
      ],
      supportedLocales: const[
        Locale("fa", "IR"), 
      ],
      locale:const Locale("fa", "IR"),
      debugShowCheckedModeBanner: false,
      theme: _themeMode==ThemeMode.light?ConfigThemeApp.light().getTheme() : ConfigThemeApp.dark().getTheme(),
      home:
          Directionality(textDirection: TextDirection.rtl, child: MainScreen(onTapChangeLightMode:(isLightMode){
             setState(() {
                if(isLightMode){
                    _themeMode = ThemeMode.light;
              }else{
                _themeMode=ThemeMode.dark;
              }
             });

          })),
    );
  }
}

const int profileIndex = 0;
const int homeIndex = 1;
const int cartIndex = 2;

class MainScreen extends StatefulWidget {
  MainScreen({super.key, required this.onTapChangeLightMode});
  final Function(bool isLightMode) onTapChangeLightMode;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int indextSelected = homeIndex;

  GlobalKey<NavigatorState> _homeState = GlobalKey();
  GlobalKey<NavigatorState> _profileState = GlobalKey();
  GlobalKey<NavigatorState> _cartState = GlobalKey();

  late final map = {
    profileIndex: _profileState,
    homeIndex: _homeState,
    cartIndex: _cartState
  };
  final _history = [];

  Future<bool> _onWillPop() async {
    final NavigatorState currentState = map[indextSelected]!.currentState!;

    if (currentState.canPop()) {
      currentState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        indextSelected = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: indextSelected,
          selectedItemColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.background,
          onTap: (index) {
            setState(() {
              _history.remove(indextSelected);
              _history.add(indextSelected);
              indextSelected = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled), label: 'profile'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: ValueListenableBuilder(
                  valueListenable: CartRepositoryImpl.valueNotifierCount,
                  builder: (context, value, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(CupertinoIcons.cart),
                        Positioned(
                            right: -12,
                            child: BadgeScreen(
                              count:
                                  CartRepositoryImpl.valueNotifierCount.value,
                            ))
                      ],
                    );
                  },
                ),
                label: 'cart'),
          ],
        ),
        body: IndexedStack(
          index: indextSelected,
          children: [
            Navigator(
              key: _profileState,
              onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: ((context) =>  ProfileScreen(onTapChangeThem: widget.onTapChangeLightMode ,))),
            ),
            Navigator(
              key: _homeState,
              onGenerateRoute: (settings) =>
                  MaterialPageRoute(builder: ((context) => const HomeScreen())),
            ),
            Navigator(
              key: _cartState,
              onGenerateRoute: (settings) =>
                  MaterialPageRoute(builder: ((context) => const CartScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
