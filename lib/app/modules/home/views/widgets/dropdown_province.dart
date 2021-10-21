import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myongkir/app/data/models/province_model.dart';
import 'package:myongkir/app/modules/home/controllers/home_controller.dart';

class DropdownProvince extends GetView<HomeController> {
  final String tipe;

  DropdownProvince({required this.tipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        showClearButton: true,
        showSearchBox: true,
        itemAsString: (item) => item!.province!,
        dropdownSearchDecoration: InputDecoration(
            label: Text(tipe == "asal" ? "Province Asal" : "Province Tujuan"),
            hintText: tipe == "asal"
                ? "Pilih Province Asal"
                : "Pilih Province Tujuan",
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
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
        onChanged: (prov) {
          if (tipe == "asal") {
            if (prov != null) {
              controller.selectedProvinceOrigin.value = true;
              controller.provinceOriginId.value = prov.provinceId!;
            } else {
              controller.selectedProvinceOrigin.value = false;
              controller.provinceOriginId.value = "0";
            }
          } else {
            if (prov != null) {
              controller.selectedProvinceDestination.value = true;
              controller.provinceDestinationId.value = prov.provinceId!;
            } else {
              controller.selectedProvinceDestination.value = false;
              controller.provinceDestinationId.value = "0";
            }
          }
        },
        popupItemBuilder: (context, province, isSelected) => Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(province.province!)),
      ),
    );
  }
}
