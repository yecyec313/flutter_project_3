import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/Theme.dart';
import 'package:flutter_ali_nike/data/repo/auth_repository.dart';
import 'package:flutter_ali_nike/data/repo/cart_repository.dart';
import 'package:flutter_ali_nike/ui/login%20or%20sign%20up/auth.dart';
import 'package:flutter_ali_nike/ui/profile/favorites.dart';
import 'package:flutter_ali_nike/ui/profile/sefareshScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' پروفایل'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
          valueListenable: IAuthRepository.authChangeNotifier,
          builder: (context, authData, index) {
            bool isAuth = authData != null && authData.accessToken.isNotEmpty;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 60, bottom: 10),
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: Image.asset(
                        "assets/img/nike_logo.png",
                        width: 140,
                      )),
                  Text(isAuth ? authData.email : "کاربر میهمان"),
                  const SizedBox(
                    height: 24,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FavoriteScreen()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 42,
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.heart),
                            SizedBox(
                              width: 8,
                            ),
                            Text("لیست علاقه مندی ها"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrderScreen()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 42,
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.cart),
                            SizedBox(
                              width: 8,
                            ),
                            Text("سوابق سفارش"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      isAuth
                          ? showDialog(
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text("خروج از حساب کاربری"),
                                    content: Text(
                                      "آیا می خواهید از حساب کاربری خود خارج شوید",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .apply(
                                              color: LightThemeColor
                                                  .secondaryTextColor,
                                              fontWeightDelta: 2),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("خیر")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            repositoryAuth.signOut();
                                            ICartRepository.conyChangeNotifier
                                                .value = false;
                                            ICartRepository
                                                .countChangeNotifier.value = 0;
                                          },
                                          child: const Text("بله"))
                                    ],
                                  ),
                                );
                              })
                          : Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 42,
                        child: Row(
                          children: [
                            Icon(isAuth
                                ? CupertinoIcons.arrow_right_square
                                : CupertinoIcons.arrow_left_right_square),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(isAuth
                                ? "خروج از حساب کاربری"
                                : "ورود به حساب کاربری"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
