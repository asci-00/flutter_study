import 'dart:convert';

import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/const/data.dart';
import '../../common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name;
  String password;
  final dio = Dio();

  _LoginScreenState()
      : name = "",
        password = "";

  Future<bool> login(final String name, final String password) async {
    final rawString = '$name:$password';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String token = stringToBase64.encode(rawString);

    final resp = await dio.post(
      'http://$ip/auth/login',
      options: Options(
        headers: {
          'authorization': 'Basic $token',
        },
      ),
    );

    final refreshToken = resp.data['refreshToken'];
    final accessToken = resp.data['accessToken'];

    await storage.write(key: refreshTokenKey, value: refreshToken);
    await storage.write(key: accessTokenKey, value: accessToken);

    if (!mounted) return false;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const RootTab()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16.0),
                const _SubTitle(),
                Image.asset(
                  'assets/img/misc/logo.png',
                  height: MediaQuery.of(context).size.height / 5 * 2,
                ),
                const SizedBox(height: 32.0),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    try {
                      login(name, password);
                    } catch (e) {
                      print(e);
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text('로그인'),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: const Text('회원가입'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: bodyTextColor,
      ),
    );
  }
}
