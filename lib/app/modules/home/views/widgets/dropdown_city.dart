import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myongkir/app/data/models/city_model.dart';
import 'package:myongkir/app/modules/home/controllers/home_controller.dart';

class DropdownCity extends GetView<HomeController> {
  final String provId;
  final String tipe;
  DropdownCity({required this.provId, required this.tipe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        showSearchBox: true,
        itemAsString: (item) => "${item!.type}  ${item.cityName!}",
        dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            label: Text("City"),
            hintText: tipe == "asal" ? "Pilih Kota Asal" : "Pilih Kota Tujuan",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        onFind: (filter) async {
          try {
            var response = await http.get(
                Uri.parse(
                    "https://api.rajaongkir.com/starter/city?province=$provId"),
                headers: {"key": "0cc76a08873c69a81f2e035e599d3da0"});
            var data = jsonDecode(response.body) as Map<String, dynamic>;

            if (data['rajaongkir']['status']['code'] != 200) {
              throw data['rajaongkir']['status']['description'];
            }

            var myList = data['rajaongkir']['results'];

            var models = City.fromJsonList(myList);
            return models;
          } catch (err) {
            print(err);
            return List<City>.empty();
          }
        },
        onChanged: (city) {
          if (tipe == "asal") {
            if (city != null) {
              controller.cityOriginId.value = city.cityId!;
            } else {
              controller.cityOriginId.value = "0";
            }
          } else {
            if (city != null) {
              controller.cityDestinationId.value = city.cityId!;
            } else {
              controller.cityDestinationId.value = "0";
            }
          }
        },
        popupItemBuilder: (context, city, isSelected) => Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("${city.type}  ${city.cityName!}")),
      ),
    );
  }
}
