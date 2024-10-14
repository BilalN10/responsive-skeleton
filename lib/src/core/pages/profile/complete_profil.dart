import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/src/model/app_model.dart';
import 'package:skeleton_kosmos/src/model/config/complete_account_theme.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

//TODO Mobile

/// Template affichant une popup permettant à l'utilisateur de compléter son profil.
///
/// {@category Page}
/// {@category Core}
class CompleteProfilPopup extends StatefulHookConsumerWidget {
  final String? title;

  final BuildContext context;

  const CompleteProfilPopup({
    Key? key,
    this.title,
    required this.context,
  }) : super(key: key);

  @override
  ConsumerState<CompleteProfilPopup> createState() => _CompleteProfilPopupState();
}

class _CompleteProfilPopupState extends ConsumerState<CompleteProfilPopup> {
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _form2Key = GlobalKey<FormState>();
  Map<String, dynamic> data = {};
  int actualPage = 0;
  final appModel = GetIt.instance<ApplicationDataModel>();
  final themeData = loadThemeData(null, "complete_account", () => const CompleteAccountThemeData())!;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        _buildPrincipalDataForm(context),
        _buildSecondaryDataForm(context),
      ],
    );
  }

  _buildPrincipalDataForm(BuildContext context) {
    return Padding(
      padding: getResponsiveValue(context, defaultValue: EdgeInsets.zero, tablet: EdgeInsets.symmetric(horizontal: formatWidth(22)), phone: EdgeInsets.symmetric(horizontal: formatWidth(22))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(widget.title ?? "complete-account.title".tr(), style: themeData.titleStyle),
          ),
          sh(20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormGenerator.generateField(
                  context,
                  FieldFormModel(
                    tag: "firstname",
                    fieldName: "Prénom",
                    type: FormFieldType.text,
                    placeholder: "John",
                    requiredForForm: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "complete-account.error.firstname".tr();
                      }
                      return null;
                    },
                  ),
                  onChanged: (value) => data["firstname"] = value,
                ),
                sh(themeData.spacing ?? 10),
                FormGenerator.generateField(
                  context,
                  FieldFormModel(
                    tag: "lastname",
                    fieldName: "Nom",
                    type: FormFieldType.text,
                    placeholder: "Doe",
                    requiredForForm: true,
                    validator: (value) => value == null || value.isEmpty ? "complete-account.error.name".tr() : null,
                  ),
                  onChanged: (value) => data["lastname"] = value,
                ),
                sh(themeData.spacing ?? 10),
              ],
            ),
          ),
          sh(themeData.spacing ?? 10),
          Center(
            child: CTA.primary(
              textButton: "utils.next".tr(),
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _pageController.jumpToPage(actualPage++);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSecondaryDataForm(BuildContext context) {
    return Padding(
      padding: getResponsiveValue(context, defaultValue: EdgeInsets.zero, tablet: EdgeInsets.symmetric(horizontal: formatWidth(22)), phone: EdgeInsets.symmetric(horizontal: formatWidth(22))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(widget.title ?? "complete-account.title".tr(), style: themeData.titleStyle),
          ),
          sh(20),
          Form(
            key: _form2Key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormGenerator.generateField(
                  context,
                  FieldFormModel(
                    tag: "profil-picture",
                    fieldName: "profil-picture".tr(),
                    type: FormFieldType.image,
                    requiredForForm: true,
                  ),
                ),
                sh(10),
              ],
            ),
          ),
          sh(10),
          CTA.primary(
            textButton: "utils.validate".tr(),
            onTap: () async {
              if (_form2Key.currentState?.validate() ?? false) {
                // if (data["profil-picture"] == null) {
                //   NotifBanner.showToast(context: context, fToast: FToast().init(context), subTitle: "complete-profil.error.photo".tr());
                //   return;
                // }//TODO add photo validator + Add to firebase Storage
                await FirebaseFirestore.instance.collection(appModel.userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).update({...data, "profilCompleted": true});
                Navigator.of(widget.context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
