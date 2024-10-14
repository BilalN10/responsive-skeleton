import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SelectableText(
          "authentication.logout.content".tr(),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
