import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:myongkir/app/data/models/city_model.dart';
import 'package:myongkir/app/data/models/courier_model.dart';
import 'package:myongkir/app/modules/home/views/widgets/dropdown_city.dart';
import 'package:myongkir/app/modules/home/views/widgets/dropdown_province.dart';
import 'package:myongkir/app/modules/home/views/widgets/field_barang.dart';
import 'package:myongkir/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  void _countCost(
      String origin, String destination, int weight, String courier) async {
    try {
      var data =
          await controller.countCost(origin, destination, weight, courier);

      var originModel = City.fromJson(data['origin_details']);
      var destinationModel = City.fromJson(data['destination_details']);
      var listCourier = Courier.fromJson(data['results'][0]);
      Get.toNamed(Routes.COST, arguments: {
        "origin_details": originModel,
        "destination_details": destinationModel,
        "weight": controller.berat,
        "couriers": listCourier
      });
    } catch (e) {
      print(e);
      Get.snackbar("info", e.toString().split(".").last,
          backgroundColor: Colors.yellowAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.loading.value,
        child: Scaffold(
            appBar: AppBar(
              title: Text('My Ongkir'),
              centerTitle: true,
            ),
            body: ListView(
              padding: EdgeInsets.all(20),
              children: [
                TextButton(
                    onPressed: () => Get.toNamed(Routes.MYMAP),
                    child: Text("Map")),
                DropdownProvince(
                  tipe: "asal",
                ),
                Obx(
                  () => controller.selectedProvinceOrigin == true
                      ? DropdownCity(
                          provId: controller.provinceOriginId.value,
                          tipe: "asal",
                        )
                      : SizedBox(),
                ),
                DropdownProvince(
                  tipe: "tujuan",
                ),
                Obx(
                  () => controller.selectedProvinceDestination == true
                      ? DropdownCity(
                          provId: controller.provinceDestinationId.value,
                          tipe: "tujuan",
                        )
                      : SizedBox(),
                ),
                FieldBarang(),
                SizedBox(
                  height: 20,
                ),
                DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  items: ["JNE", "POS", "TIKI"],
                  dropdownSearchDecoration: InputDecoration(
                      label: Text("Jasa Pengiriman"),
                      hintText: "Pilih Jasa Pengiriman",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onChanged: (val) {
                    print(val);
                    if (val != null) {
                      controller.courierCode.value = val.toLowerCase();
                    } else {
                      Get.defaultDialog(
                          title: "Info",
                          middleText: "Kurir tidak boleh kosong");
                    }
                  },
                  selectedItem: "JNE",
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _countCost(
                          controller.cityOriginId.value,
                          controller.cityDestinationId.value,
                          controller.berat.toInt(),
                          controller.courierCode.value);
                    },
                    child: Text("Proses"))
              ],
            )),
      ),
    );
  }
}
