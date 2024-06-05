import 'package:flutter/material.dart';
import 'package:generate_invoice_app/ui/client_screen/client_screen.dart';
import 'package:generate_invoice_app/ui/home_screen/home_screen.dart';
import 'package:generate_invoice_app/ui/profile_screen/profile_view.dart';
import 'package:get/get.dart';
import 'controller/bottombar_controller.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  BottomBarController bottomBarController = Get.put(BottomBarController());
  List screens = [
    const HomeScreen(),
    const ClientScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    bottomBarController.getGenerateInvoiceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<BottomBarController>(builder: (controller) {
      return Scaffold(
          extendBody: true,
          bottomNavigationBar: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: BottomNavigationBar(
                  onTap: (index) {
                    controller.updateBottomBar(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  //  backgroundColor: darkModeBottomBarColor,
                  //  selectedItemColor: whiteColor,
                  //  unselectedItemColor: whiteColor,
                  currentIndex: controller.selected,
                  items: [
                    BottomNavigationBarItem(
                        icon: controller.selected == 0 ? const Icon(Icons.home) : const Icon(Icons.home_outlined), label: "Home"),
                    BottomNavigationBarItem(
                        icon: controller.selected == 1 ? const Icon(Icons.redeem) : const Icon(Icons.redeem_outlined), label: "Clients"),
                    BottomNavigationBarItem(
                        icon: controller.selected == 2 ? const Icon(Icons.person) : const Icon(Icons.person_outline), label: "Profile"),
                  ],
                ),
              ),
            ],
          ),
          body: screens[controller.selected]);
    });
  }
}
