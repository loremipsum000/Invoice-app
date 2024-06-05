import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // TabController? tabController;
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   tabController =
  //       TabController(length: 3, vsync: HomeScreenTickerProvider(this));
  //   super.onInit();
  // }

  List popUpList = ["DownLoad", "Mark as Paid", "Share", "Delete"];
}

class HomeScreenTickerProvider extends TickerProvider {
  final HomeController controller;
  HomeScreenTickerProvider(this.controller);

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
