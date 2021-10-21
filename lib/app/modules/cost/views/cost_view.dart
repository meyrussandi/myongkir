import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:myongkir/app/data/models/city_model.dart';
import 'package:myongkir/app/data/models/courier_model.dart';

import '../controllers/cost_controller.dart';

class CostView extends GetView<CostController> {
  final City originModel = Get.arguments['origin_details'];
  final City destinationModel = Get.arguments['destination_details'];
  final Courier courierModel = Get.arguments['couriers'];
  final double weight = Get.arguments['weight'];

  String _getImage(String courierCode) {
    switch (courierCode) {
      case "jne":
        return "assets/icons/jne.png";
      case "tiki":
        return "assets/icons/tiki.png";
      case "pos":
        return "assets/icons/pos.png";
      default:
        return "assets/icons/courier.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(Get.arguments['origin_details']);
    print(courierModel.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.3),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.dstOut),
                          image: AssetImage(
                            _getImage(courierModel.code!),
                          ))),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: (Get.width - (2 * 16)) / 2,
                        child: Text(
                          'Asal Pengiriman',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: (Get.width - (2 * 16)) / 2,
                        child: Text(
                          'Tujuan Pengiriman',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  _cityCard("Provinsi", originModel.province,
                      destinationModel.province),
                  _cityCard(
                      "Kota", originModel.cityName, destinationModel.cityName),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Berat barang : ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        weight.toInt().toString() + " gram",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Jasa Pengiriman",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    courierModel.name!,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (ctx, i) => Divider(),
                        itemCount: courierModel.costs!.length,
                        itemBuilder: (ctx, ind) {
                          return ListTile(
                            title: Text(
                              courierModel.costs![ind].service.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(courierModel.costs![ind].description
                                .toString()),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Rp. " +
                                      courierModel.costs![ind].cost![0].value
                                          .toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text(
                                    courierModel.costs![ind].cost![0].etd
                                            .toString() +
                                        (courierModel.costs![ind].cost![0].etd!
                                                .toLowerCase()
                                                .contains("hari")
                                            ? ""
                                            : " Hari"),
                                    style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _cityCard(String title, originValue, destinationValue) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: (Get.width - (2 * 16)) / 2,
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              width: (Get.width - (2 * 16)) / 2,
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: (Get.width - (2 * 16)) / 2,
              child: Text(
                originValue,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: (Get.width - (2 * 16)) / 2,
              child: Text(
                destinationValue,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
