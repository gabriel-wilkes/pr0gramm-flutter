import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

import 'baseApi.dart';
import 'dtos/LoginResponse.dart';
import 'dtos/captcha.dart';

class LoginApi extends BaseApi {
  Future<Captcha> getCaptcha() async {
    final response = await client.get("/user/captcha");
    return Captcha.fromJson(response.data);
  }

  Future<LoginResponse> doLogin(
      {String user, String pass, Captcha captcha}) async {
    final body = {
      "name": user,
      "password": pass,
      "captcha": captcha.captchaResult,
      "token": captcha.token
    };

    try {
      final response = await client.post(
        "/user/login",
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final cookies = apiClient.getCookies();
      final meCookie = cookies.firstWhere((c) => c.name == "me");
      final decodedMe = Uri.decodeComponent(meCookie.value);
      final meJson = MeCookie.fromJson(jsonDecode(decodedMe));

      final loginResponse = LoginResponse.fromJson(response.data);
      loginResponse.username = meJson.name;

      return loginResponse;
    } on DioError {
      return LoginResponse(success: false);
    }
  }
}

class MeCookie {
  String name;
  String id;
  int a;
  String pp;
  bool paid;

  MeCookie({this.name, this.id, this.a, this.pp, this.paid});

  MeCookie.fromJson(Map<String, dynamic> json) {
    name = json['n'];
    id = json['id'];
    a = json['a'];
    pp = json['pp'];
    paid = json['paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['n'] = this.name;
    data['id'] = this.id;
    data['a'] = this.a;
    data['pp'] = this.pp;
    data['paid'] = this.paid;
    return data;
  }
}