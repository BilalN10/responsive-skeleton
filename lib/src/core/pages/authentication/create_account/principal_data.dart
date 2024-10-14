// ignore_for_file: must_call_super

import 'package:auth_helper/auth_helper.dart' as ah;
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/core/pages/authentication/create_account_page.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart';

class PrincipalData extends StatefulHookConsumerWidget {
  final bool haveRepeatPassword;
  final bool isLoginById;
  final bool isLast;
  final bool createAccount;
  final Widget Function(BuildContext, WidgetRef)? cguContentBuilder;

  const PrincipalData({
    Key? key,
    this.cguContentBuilder,
    this.haveRepeatPassword = true,
    this.isLoginById = false,
    this.isLast = false,
    this.createAccount = true,
  }) : super(key: key);

  @override
  ConsumerState<PrincipalData> createState() => _PrincipalDataState();
}

class _PrincipalDataState extends ConsumerState<PrincipalData> with AutomaticKeepAliveClientMixin<PrincipalData> {
  String? email;
  String? password;
  String? repeatPassword;
  PhoneNumber? phone;
  late PhoneNumber _initialPhoneNumber;

  final fToast = FToast();
  final GlobalKey<FormState> key = GlobalKey();

  //Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController rPassController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  //FocusNode
  final FocusNode emailNode = FocusNode();
  final FocusNode passNode = FocusNode();
  final FocusNode rPassNode = FocusNode();
  final FocusNode phoneNode = FocusNode();

  final appModel = GetIt.instance<ApplicationDataModel>();
  late final AuthenticationPageThemeData theme;

  @override
  void initState() {
    super.initState();
    _initialPhoneNumber = PhoneNumber(isoCode: "FR");
    theme = loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;
    fToast.init(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    emailNode.dispose();
    passController.dispose();
    passNode.dispose();
    rPassController.dispose();
    rPassNode.dispose();
    phoneController.dispose();
    phoneNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text("authentication.create-account.title".tr(),
                style: (theme.titleStyle ??
                    TextStyle(
                      fontSize: sp(22),
                      color: const Color(0xFF021C36),
                      fontWeight: FontWeight.w600,
                    ))),
          ),
          sh(28),
          if (appModel.applicationConfig.createAccountNeedEmail) ...[
            FormGenerator.generateField(
              context,
              FieldFormModel(
                tag: widget.isLoginById ? "id" : "email",
                type: FormFieldType.email,
                onChanged: (val) => email = val,
                validator: (val) => AuthValidator.validEmail(val)?.tr(),
                placeholder: (widget.isLoginById ? "field.id.hint" : "field.email.hint").tr(),
                fieldName: (widget.isLoginById ? "field.id.title" : "field.email.title").tr(),
              ),
            ),
            sh(14),
          ] else if (appModel.applicationConfig.createAccountNeedPhone) ...[
            FormGenerator.generateField(
              context,
              FieldFormModel(
                initialValue: _initialPhoneNumber,
                tag: "phone",
                type: FormFieldType.phone,
                validator: (val) =>
                    val != null && (val as String).isNotEmpty ? null : "field.form-validator.required-field".tr(),
                onChanged: (val) => phone = val,
                placeholder: "field.phone.hint".tr(),
                fieldName: "field.phone.title".tr(),
              ),
            ),
            sh(14),
          ],
          FormGenerator.generateField(
            context,
            FieldFormModel(
              tag: "password",
              type: FormFieldType.password,
              onChanged: (val) => password = val,
              validator: (val) => AuthValidator.validPassword(val)?.tr(),
              placeholder: "field.password.hint".tr(),
              fieldName: "field.password.title".tr(),
            ),
          ),
          if (widget.haveRepeatPassword) ...[
            sh(14),
            FormGenerator.generateField(
              context,
              FieldFormModel(
                tag: "repeatPassword",
                type: FormFieldType.password,
                onChanged: (val) => repeatPassword = val,
                validator: (val) => AuthValidator.validSamePassword(val, password)?.tr(),
                fieldName: "field.password.repeat-title".tr(),
                placeholder: "field.password.hint".tr(),
              ),
            ),
          ],
          if (appModel.applicationConfig.createAccountNeedPhone || appModel.applicationConfig.showPhoneNumber) ...[
            sh(14),
            FormGenerator.generateField(
              context,
              FieldFormModel(
                initialValue: _initialPhoneNumber,
                tag: "phone",
                type: FormFieldType.phone,
                validator: (val) => val != null && (val as String).isNotEmpty
                    // &&
                    // (RegExp(r'^\+33[1-9]\d{8}$').hasMatch(phone?.phoneNumber ?? ""))
                    ? null
                    : "field.form-validator.required-field".tr(),
                onChanged: (val) => phone = val,
                placeholder: "field.phone.hint".tr(),
                fieldName: "field.phone.title".tr(),
              ),
            ),
          ],
          sh(37),
          CTA.primary(
            textButton: "utils.continue-to-next".tr(),
            onTap: () async {
              await _createAccount();
            },
          ),
        ],
      ),
    );
  }

  _createAccount() async {
    if ((key.currentState?.validate() ?? false)) {
      if (await AuthService.emailDoesExist(email!)) {
        NotifBanner.showToast(
            context: context, fToast: fToast, subTitle: "field.form-validator.firebase.email-already-in-use".tr());
        return;
      }
      if (phone != null && await AuthService.phoneDoesExist(phone!.phoneNumber!)) {
        NotifBanner.showToast(
            context: context, fToast: fToast, subTitle: "field.form-validator.firebase.phone-already-in-use".tr());
        return;
      }
      ref.read(createAccountProvider).addFieldData("email", email);
      ref.read(createAccountProvider).addFieldData("password", password);
      ref.read(createAccountProvider).addFieldData("phone", phone?.phoneNumber);

      ref.read(createAccountProvider).email = email;
      ref.read(createAccountProvider).password = password;
      ref.read(createAccountProvider).phone = phone;

      if (getResponsiveValue(context, defaultValue: false, tablet: true, phone: true)) {
        ValueNotifier<bool> notifier = ValueNotifier<bool>(false);
        ValueNotifier<bool> cguError = ValueNotifier<bool>(false);

        final rep = await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints(
            maxHeight: formatHeight(800),
            minHeight: formatHeight(650),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(theme.modalBottomRadius ?? 20),
              topRight: Radius.circular(theme.modalBottomRadius ?? 20),
            ),
          ),
          isScrollControlled: true,
          builder: (_) {
            return Container(
              padding: EdgeInsets.fromLTRB(29.w, 16.h, 29.w, 69.h),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: theme.resetPasswordBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(theme.modalBottomRadius ?? 20),
                  topRight: Radius.circular(theme.modalBottomRadius ?? 20),
                ),
              ),
              constraints: BoxConstraints(
                maxHeight: formatHeight(800),
                minHeight: formatHeight(650),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 43.w,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.resetPasswordEncocheColor ?? const Color(0xFFDBDBDB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    sh(20),
                    SizedBox(
                      width: 280.w,
                      child: Text(
                        "authentication.cgu.title".tr(),
                        style: theme.titleStyle?.copyWith(fontSize: sp(18)) ??
                            TextStyle(
                              fontSize: sp(18),
                              color: const Color(0xFF021C36),
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    sh(17),
                    SizedBox(
                      height: 310.h,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        primary: false,
                        child: widget.cguContentBuilder != null
                            ? widget.cguContentBuilder!(context, ref)
                            : Text(
                                appModel.applicationConfig.cguContent,
                                style: theme.subTitleStyle ??
                                    TextStyle(
                                        color: const Color(0xFF02132B).withOpacity(.35),
                                        fontSize: sp(13),
                                        fontWeight: FontWeight.w500),
                              ),
                      ),
                    ),
                    sh(16),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: notifier,
                            builder: (_, bool val, __) {
                              return CustomCheckbox.square(
                                isChecked: val,
                                size: 26,
                                onTap: () => notifier.value = !notifier.value,
                              );
                            }),
                        sw(14),
                        Expanded(
                          child: InkWell(
                            onTap: () => notifier.value = !notifier.value,
                            child: ValueListenableBuilder(
                              valueListenable: cguError,
                              builder: (_, bool val, __) {
                                return Text(
                                  "authentication.cgu.accept".tr(),
                                  style: theme.subTitleStyle?.copyWith(
                                          fontSize: sp(11),
                                          color: val ? Colors.red : null,
                                          fontWeight: FontWeight.w500) ??
                                      TextStyle(
                                          color: val ? Colors.red : const Color(0xFF02132B),
                                          fontSize: sp(11),
                                          fontWeight: FontWeight.w500),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    sh(33),
                    Center(
                      child: CTA.primary(
                        width: theme.cguCtaWidth,
                        textButton: "utils.continue-to-next".tr(),
                        onTap: () async {
                          if (!notifier.value) {
                            cguError.value = true;
                            return;
                          }
                          Navigator.of(context).pop(true);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
        if (rep != true) {
          NotifBanner.showToast(context: context, fToast: fToast, subTitle: "authentication.cgu.required".tr());
          return;
        }
      }

      if (widget.createAccount) {
        final rep = await AuthService.signUpWithEmail(email!, password!);
        if (rep.type == "error") {
          NotifBanner.showToast(context: context, fToast: fToast, subTitle: rep.message.tr());
          passController.clear();
          rPassController.clear();
          return;
        }

        await FirebaseFirestore.instance
            .collection(appModel.userCollectionPath)
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          "email": email,
          "phone": phone?.phoneNumber,
          "cguAccepted": true,
          "profilCompleted": false,
          "createdAt": Timestamp.now(),
        });

        FirebaseAuth.instance.currentUser!.sendEmailVerification();

        AutoRouter.of(context).pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);

        return;
      }

      if (appModel.applicationConfig.createAccountNeedPhone) {
        await ah.AuthService.verifPhoneNumberAndGetCredential(
          phone: phone!.phoneNumber!,
          connexionDone: () {},
          verificationFailed: (_) {},
          verificationError: (_) {},
          codeSent: (_, __) {
            ref.read(createAccountProvider).setSmsProvider(_);
          },
          redirectAfterTimeOut: (_) {},
          setLoading: () {},
          fToast: fToast,
          context: context,
        );
      }

      if (!widget.isLast) {
        ref.read(createAccountProvider).updatePage(ref.read(createAccountProvider).actualPage + 1);
      } else if (GetIt.I<ApplicationDataModel>().applicationConfig.emailMustBeVerified) {
        final r = await showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) {
            return const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(child: VerificationEmailSendPage.mobile()),
            );
          },
        );
        if (r == true) {
          printInDebug("end create account");
          AutoRouter.of(context).pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
        } else {
          AutoRouter.of(context).replaceNamed("/login");
        }

        return;
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
