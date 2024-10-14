import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

class ModifyPersonnalDataNode extends StatefulHookConsumerWidget {
  final bool modifyFirstname;
  final bool modifyLastname;
  final bool modifyPhone;

  const ModifyPersonnalDataNode({
    Key? key,
    this.modifyFirstname = true,
    this.modifyLastname = true,
    this.modifyPhone = true,
  }) : super(key: key);

  @override
  ConsumerState<ModifyPersonnalDataNode> createState() => _ModifyPersonnalDataNodeState();
}

class _ModifyPersonnalDataNodeState extends ConsumerState<ModifyPersonnalDataNode> {
  late String? firstname;
  late String? lastname;
  late String? phone;

  @override
  void initState() {
    firstname = ref.read(userChangeNotifierProvider).userData!.firstname;
    lastname = ref.read(userChangeNotifierProvider).userData!.lastname;
    phone = ref.read(userChangeNotifierProvider).userData!.phone;
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
          if (widget.modifyFirstname) ...[
            FormGenerator.generateField(
              context,
              FieldFormModel(
                tag: "firstname",
                type: FormFieldType.text,
                onChanged: (val) => firstname = val,
                placeholder: "field.firstname.hint".tr(),
                fieldName: "field.firstname.title".tr(),
                initialValue: firstname,
              ),
            ),
            sh(14),
          ],
          if (widget.modifyLastname) ...[
            FormGenerator.generateField(
              context,
              FieldFormModel(
                tag: "lastname",
                type: FormFieldType.text,
                onChanged: (val) => lastname = val,
                placeholder: "field.lastname.hint".tr(),
                fieldName: "field.lastname.title".tr(),
                initialValue: lastname,
              ),
            ),
            sh(14),
          ],
          if (widget.modifyPhone) ...[
            FormGenerator.generateField(
              context,
              FieldFormModel(
                tag: "phone",
                type: FormFieldType.text,
                onChanged: (val) => phone = val,
                placeholder: "field.phone.hint".tr(),
                fieldName: "field.phone.title".tr(),
                initialValue: phone,
              ),
            ),
            sh(14),
          ],
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
