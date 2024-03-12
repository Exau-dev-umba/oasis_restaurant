import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/AuthenticationModel.dart';
import '../utils/Constantes/Constantes.dart';
import '../utils/Endpoints.dart';
import '../utils/Requests.dart';
import '../utils/StockageKeys.dart';

class AuthenticationController with ChangeNotifier {

  AuthenticationController({this.stockage});

  String? token;
  AuthenticationModel? user;
  GetStorage? stockage;
  bool res = false;
  List<AuthenticationModel> auth = [];
  bool loading = false;

/*  Future<HttpResponse> logout(Map data) async{
    var url="${Endpoints.logout}";
    var tkn = stockage?.read(StockageKeys.token);
    HttpResponse response = await postData(url, data, token: tkn);
    if(response.status){
      notifyListeners();
    }
    print(response.data);
    return response;
  }*/

  Future<HttpResponse>login(Map data) async{
    var url="${Endpoints.login}";
    HttpResponse response = await postData(url, data);
    if(response.data?['status']==202){
      user=AuthenticationModel.fromJson(response.data?['user'] ?? {});
      stockage?.write(StockageKeys.token, response.data?["access_token"]?? "");
      notifyListeners();
      print("DATA OK : ${response.data}");
    }
    print("DATA : ${response}");
    return response;
  }

  Future<HttpResponse> register(Map data) async{
    var url = "${Endpoints.register}";
    HttpResponse response = await postData(url, data);
    if (response!=null && response.data?['status']==201){
      stockage?.write(StockageKeys.token, response.data?["access_token"]) ;
      print("DATA OK : ${response.data}");
      notifyListeners();
    }
    return response;
  }

  Future<bool> checkConnexion() async {
    try {
      final result = await InternetAddress.lookup('admin.oasis-rdc.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        print(result);
      }
      return true;
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

/*  void recuperInfoUser() async{
    var url=Uri.parse("${Constantes.BASE_URL}${Endpoints.infosUser}");
    loading=true;
    notifyListeners();
    var reponse= await http.get(url);
    print(reponse.runtimeType);
    print(reponse.body.runtimeType);
    print(reponse.body);
    print(reponse.statusCode);
    loading=false;
    notifyListeners();
  }*/
}

void main(){
  Map data = {
    "email":"umbaexauce233@gmail.com",
    "password":"Oasis-rdc"
  };
  var c = AuthenticationController();
  //c.login(data);
  c.checkConnexion();
}