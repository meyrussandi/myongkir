import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myongkir/app/data/models/province_model.dart';
import 'package:myongkir/app/data/models/city_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Ongkir'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            DropdownProvince(),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.selectedProvince == true
                  ? DropdownCity(
                      provId: controller.provinceId.value,
                    )
                  : SizedBox(),
            )
          ],
        ));
  }
}

class DropdownCity extends StatelessWidget {
  final String provId;
  DropdownCity({required this.provId});
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<City>(
      showSearchBox: true,
      itemAsString: (item) => "${item!.type}  ${item.cityName!}",
      dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          label: Text("City"),
          hintText: "Pilih Kota",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
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
      popupItemBuilder: (context, city, isSelected) => Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("${city.type}  ${city.cityName!}")),
    );
  }
}

class DropdownProvince extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Province>(
      showSearchBox: true,
      itemAsString: (item) => item!.province!,
      dropdownSearchDecoration: InputDecoration(
          label: Text("Provinsi"),
          hintText: "Pilih Provinsi",
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
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
        if (prov != null) {
          controller.selectedProvince.value = true;
          controller.provinceId.value = prov.provinceId!;
        }
      },
      popupItemBuilder: (context, province, isSelected) => Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(province.province!)),
    );
  }
}
