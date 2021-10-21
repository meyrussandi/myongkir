import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var selectedProvinceOrigin = false.obs;
  var selectedProvinceDestination = false.obs;
  var provinceOriginId = "".obs;
  var provinceDestinationId = "".obs;
  var cityOriginId = "".obs;
  var cityDestinationId = "".obs;
  var courierCode = "jne".obs;
  var loading = false.obs;

  double berat = 0.0;
  String satuan = "gram";
  late TextEditingController barangC;

  void loadingOn() => this.loading.value = true;
  void loadingOff() => this.loading.value = false;

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.0;
    if (satuan == 'kilogram') {
      berat = berat * 1000;
    }

    print("$berat gram");
  }

  void ubahSatuan(String value) {
    satuan = value;
    print("$berat $satuan");
  }

  Future countCost(
      String origin, String destination, int weight, String courier) async {
    loadingOn();
    try {
      Map<String, dynamic> query = {
        "origin": origin,
        "destination": destination,
        "weight": "$weight",
        "courier": courier
      };
      Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
      final res = await http.post(
        url,
        body: query,
        headers: {
          "key": "0cc76a08873c69a81f2e035e599d3da0",
          "content-type": "application/x-www-form-urlencoded",
        },
      );
      Map<String, dynamic> result = jsonDecode(res.body);

      print(res.body);
      loadingOff();
      if (result['rajaongkir']['status']['code'] == 200) {
        return result['rajaongkir'];
      } else {
        throw result['rajaongkir']['status']['description'];
      }
    } catch (e) {
      print(e);

      throw e.toString();
    }
  }

  @override
  void onInit() {
    barangC = TextEditingController(text: "0");
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
