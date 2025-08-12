import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ali_nike/data/repo/auth_repository.dart';
import 'package:flutter_ali_nike/data/repo/cart_repository.dart';
import 'package:flutter_ali_nike/ui/login%20or%20sign%20up/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController controllerUser =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController controllerPassword =
      TextEditingController(text: '123456');
  // StreamSubscription<AuthState>? streamSubscription = null;
  // @override
  // void dispose() {
  //   streamSubscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    const onBackground = Colors.white;
    final themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
            snackBarTheme: SnackBarThemeData(
                backgroundColor: themeData.colorScheme.primary,
                contentTextStyle: const TextStyle(fontFamily: 'IranYekan')),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    minimumSize:
                        WidgetStateProperty.all(const Size.fromHeight(56)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    foregroundColor: WidgetStateProperty.all(
                        themeData.colorScheme.secondary))),
            colorScheme:
                themeData.colorScheme.copyWith(onSurface: Colors.white),
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1)))),
        child: Scaffold(
            backgroundColor: themeData.colorScheme.secondary,
            body: BlocProvider<AuthBloc>(
              create: (context) {
                final bloc = AuthBloc(repositoryAuth, repositoryCart);
                bloc.stream.forEach((state) {
                  if (state is AuthSuccess) {
                    Navigator.of(context).pop();
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.exception.message)));
                  }
                  //  else {
                  //   debugPrint('state is not supported');
                  // }
                });
                bloc.add(AuthStarted());
                return bloc;
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                    return current is AuthLoading ||
                        current is AuthInitial ||
                        current is AuthError;
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/nike_logo.png',
                          color: Colors.white,
                          width: 120,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22)),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                            state.isLoginMode
                                ? 'لطفا وارد حساب کاربری خود شوید'
                                : 'ایمیل و رمز عبور خود را تعیین کنید',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: controllerUser,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white70,
                              ),
                              label: Text('آدرس ایمیل')),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _PasswordTextField(
                          onBackground: Colors.white,
                          controller: controllerPassword,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final List<ConnectivityResult> connectivityResult =
                                await (Connectivity().checkConnectivity());
                            debugPrint(connectivityResult
                                .contains(ConnectivityResult.mobile)
                                .toString());
                            if (connectivityResult
                                    .contains(ConnectivityResult.wifi) ||
                                connectivityResult
                                    .contains(ConnectivityResult.mobile)) {
                              BlocProvider.of<AuthBloc>(context).add(
                                  AuthIsButtomClick(controllerUser.text,
                                      controllerPassword.text));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('خطای نامشخص')));
                            }
                          },
                          child: state is AuthLoading
                              ? const CircularProgressIndicator()
                              : Text(state.isLoginMode ? 'ورود' : 'ثبت نام'),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isLoginMode
                                  ? 'حساب کاربری ندارید؟'
                                  : 'حساب کاربری دارید؟',
                              style: TextStyle(
                                  color: onBackground.withOpacity(0.7)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(AuthIsloginModeChange());
                              },
                              child: Text(
                                state.isLoginMode ? 'ثبت نام' : 'ورود',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: themeData.colorScheme.primary,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  const _PasswordTextField({
    Key? key,
    required this.onBackground,
    required this.controller,
  }) : super(key: key);

  final Color onBackground;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obsecureText = !obsecureText;
              });
            },
            icon: Icon(
              obsecureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBackground.withOpacity(0.6),
            )),
        label: const Text('رمز عبور'),
      ),
    );
  }
}
