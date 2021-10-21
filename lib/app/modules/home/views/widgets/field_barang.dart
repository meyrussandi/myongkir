import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myongkir/app/modules/home/controllers/home_controller.dart';

class FieldBarang extends GetView<HomeController> {
  const FieldBarang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: controller.barangC,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
              label: Text("Berat Barang"),
              hintText: "Masukan Berat Barang",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
          onChanged: (value) => controller.ubahBerat(value),
        )),
        Container(
          width: 150,
          child: DropdownSearch<String>(
              mode: Mode.MENU,
              items: [
                "gram",
                "kilogram",
              ],
              dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  label: Text("Satuan"),
                  hintText: "Pilih Satuan",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              onChanged: (value) => controller.ubahSatuan(value!),
              selectedItem: "gram"),
        )
      ],
    );
  }
}
