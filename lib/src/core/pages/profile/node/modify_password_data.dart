import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class ModifyPasswordDataNode extends StatefulHookConsumerWidget {
  const ModifyPasswordDataNode({Key? key}) : super(key: key);

  @override
  ConsumerState<ModifyPasswordDataNode> createState() => _ModifyPasswordDataNodeState();
}

class _ModifyPasswordDataNodeState extends ConsumerState<ModifyPasswordDataNode> {
  String? oldPassword;
  String? newPassword;
  String? newPasswordRepeat;

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
              tag: "old_password",
              type: FormFieldType.text,
              onChanged: (val) => oldPassword = val,
              placeholder: "field.password.hint".tr(),
              fieldName: "field.password.actual-title".tr(),
            ),
          ),
          sh(14),
          FormGenerator.generateField(
            context,
            FieldFormModel(
              tag: "new_password",
              type: FormFieldType.text,
              onChanged: (val) => newPassword = val,
              placeholder: "field.password.hint".tr(),
              fieldName: "field.password.new-title".tr(),
            ),
          ),
          sh(14),
          FormGenerator.generateField(
            context,
            FieldFormModel(
              tag: "new_password_repeat",
              type: FormFieldType.text,
              onChanged: (val) => newPasswordRepeat = val,
              placeholder: "field.password.hint".tr(),
              fieldName: "field.password.new-repeat-title".tr(),
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
