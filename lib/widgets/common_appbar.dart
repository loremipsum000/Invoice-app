import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.action = false,
    this.leadingIcon = false,
    this.onTap,
    this.actionWidget,
  });

  final String? title;
  final bool? action;
  final bool? leadingIcon;
  final Function()? onTap;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return AppBar(
      // backgroundColor: darkModePrimaryColor,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: w * 0.03),
        child: Row(
          children: [
            leadingIcon == true
                ? Padding(
                    padding: EdgeInsets.only(right: w * 0.02),
                    child: InkResponse(
                      onTap: onTap ??
                          () {
                            Get.back();
                          },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: whiteColor,
                        size: 18,
                      ),
                    ),
                  )
                : const SizedBox(),
            Text(title ?? "", style: CommonTextStyle.kWhite24OpenSansRegular),
          ],
        ),
      ),
      leadingWidth: w * 0.75,
      actions: action == true
          ? [
              actionWidget ?? const Text(""),
            ]
          : null,
    );
  }

  @override
  // TODO: implement preferredSize

  Size get preferredSize => const Size.fromHeight(50);
}
