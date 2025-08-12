// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/cart_repository.dart';
import 'package:flutter_ali_nike/ui/cart/cart.dart';
import 'package:flutter_ali_nike/ui/home/home.dart';
import 'package:flutter_ali_nike/ui/profile/profile.dart';
import 'package:flutter_ali_nike/ui/widget/bage.dart';

int home = 0;
int cart = 1;
int profile = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<int> _history = [];
  Future<bool> onWillPopali() async {
    final NavigatorState curSTNS = map[seltab]!.currentState!;
    if (curSTNS.canPop()) {
      curSTNS.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        seltab = _history.last;
        _history.removeLast();
      });
      return false;
    }

    return true;
  }

  final GlobalKey<NavigatorState> _home = GlobalKey();
  final GlobalKey<NavigatorState> _cart = GlobalKey();
  final GlobalKey<NavigatorState> _profile = GlobalKey();
  late final map = {
    home: _home,
    cart: _cart,
    profile: _profile,
  };
  int seltab = home;
  @override
  void initState() {
    repositoryCart.count();
    repositoryCart.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (alo == false) {
    //   setState(() {
    //     alo = true;
    //   });
    // }
    return WillPopScope(
        onWillPop: onWillPopali,
        child: Scaffold(
          body: IndexedStack(index: seltab, children: [
            _navigator(_home, home, const HomeScreen()),
            _navigator(_cart, cart, const CartScreen()),
            _navigator(_profile, profile, const ProfileScreen()

                // Center(
                //     child: ElevatedButton(
                //   onPressed: () {
                //     repositoryAuth.signOut();
                //     ICartRepository.conyChangeNotifier.value = false;
                //     ICartRepository.countChangeNotifier.value = 0;
                //   },
                //   child: const Text('profile'),
                // ))
                ),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(CupertinoIcons.cart),
                      Positioned(
                        right: -10,
                        child: ValueListenableBuilder<int>(
                          valueListenable: ICartRepository.countChangeNotifier,
                          builder: (context, value, child) {
                            return Bage(repos: value);
                          },
                        ),
                      )
                    ],
                  ),
                  label: 'کارت'),
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'پروفایل')
            ],
            currentIndex: seltab,
            onTap: (selectedIndex) {
              setState(() {
                _history.remove(seltab);
                _history.add(seltab);
                seltab = selectedIndex;
              });
            },
          ),
        ));
  }

  Widget _navigator(GlobalKey key, int ind, Widget child) {
    debugPrint(alo.toString() + seltab.toString());
    return key.currentState == null && seltab != ind
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) =>
                MaterialPageRoute(builder: (context) {
                  return
                      // alo == false && seltab == 1
                      //     ? child
                      //     :
                      Offstage(offstage: seltab != ind, child: child);
                }));
  }
}
