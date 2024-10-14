import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class ModifyEmailDataNode extends StatefulHookConsumerWidget {
  const ModifyEmailDataNode({Key? key}) : super(key: key);

  @override
  ConsumerState<ModifyEmailDataNode> createState() => _ModifyEmailDataNodeState();
}

class _ModifyEmailDataNodeState extends ConsumerState<ModifyEmailDataNode> {
  late String? email;
  String? password;

  @override
  void initState() {
    email = ref.read(userChangeNotifierProvider).userData!.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("utils.modify".tr(), style: TextStyle(fontSize: sp(17), fontWeight: FontWeight.w600, color: Colors.black)),
          sh(18),
          FormGenerator.generateField(
            context,
            FieldFormModel(
              tag: "email",
              type: FormFieldType.text,
              onChanged: (val) => email = val,
              placeholder: "field.email.hint".tr(),
              fieldName: "field.email.title".tr(),
              initialValue: email,
            ),
          ),
          sh(14),
          FormGenerator.generateField(
            context,
            FieldFormModel(
              tag: "password",
              type: FormFieldType.text,
              onChanged: (val) => password = val,
              placeholder: "field.password.hint".tr(),
              fieldName: "field.password.title".tr(),
            ),
          ),
          sh(14),
          CTA.primary(
            textButton: "utils.modify".tr(),
            width: formatWidth(330),
            onTap: () {
              ///TODO
            },
          ),
        ],
      ),
    );
  }
}
