import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dosen.dart';

class Services {
  static const ROOT = 'http://192.168.98.16/uas_pmob/dosen_action.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_DOSEN_ACTION = 'ADD_DOSEN';
  static const _UPDATE_DOSEN_ACTION = 'UPDATE_DOSEN';
  static const _DELETE_DOSEN_ACTION = 'DELETE_DOSEN';


  static Future<String> createTable() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    }catch(e){
      return "error";
    }
  }

  static Future<List<Dosen>> getDosen() async{
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getDosen Response: ${response.body}');
      if(200 == response.statusCode){
        List<Dosen> list = parseResponse(response.body);
        return list;
      }else{
        return List<Dosen>();
      }

    } catch(e){
      return List<Dosen>();
    }
  }

  static List<Dosen> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Dosen>((json) => Dosen.fromJson(json)).toList();
  }

  static Future<String> addDosen(String nidn_dosen, String nama_dosen) async{
    try{
      var map = Map<String, dynamic>();
      map['action'] = _ADD_DOSEN_ACTION;
      map['nidn_dosen'] = nidn_dosen;
      map['nama_dosen'] = nama_dosen;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addDosen Response: ${response.body}');
      if(200 == response.statusCode){
        return response.body;
      }else{
        return "error";
      }
    } catch(e){
      return "error";
    }
  }

  static Future<String> updateDosen(
      String id_dosen, String nidn_dosen, String nama_dosen) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_DOSEN_ACTION;
      map['id_dosen'] = id_dosen;
      map['nidn_dosen'] = nidn_dosen;
      map['nama_dosen'] = nama_dosen;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateDosen Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteDosen(String id_dosen) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_DOSEN_ACTION;
      map['id_dosen'] = id_dosen;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deleteDosen Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
