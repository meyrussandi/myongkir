import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myongkir/app/data/models/province_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomeView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            DropdownSearch<Province>(
              showSearchBox: true,
              itemAsString: (item) => item!.province!,
              dropdownSearchDecoration: InputDecoration(
                  label: Text("Provinsi"), hintText: "Pilih Provinsi"),
              onFind: (filter) async {
                try {
                  var response = await http.get(
                      Uri.parse("https://api.rajaongkir.com/starter/province"),
                      headers: {"key": "0cc76a08873c69a81f2e035e599d3da0"});
                  var data = jsonDecode(response.body) as Map<String, dynamic>;

                  if (data['rajaongkir']['status']['code'] != 200) {
                    throw data['rajaongkir']['status']['description'];
                  }

                  var myList = data['rajaongkir']['results'];

                  var models = Province.fromJsonList(myList);
                  return models;
                } catch (err) {
                  print(err);
                  return List<Province>.empty();
                }
              },
              popupItemBuilder: (context, province, isSelected) => Container(
                  padding: EdgeInsets.all(4), child: Text(province.province!)),
            )
          ],
        ));
  }
}
