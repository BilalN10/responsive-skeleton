// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:async';

import 'package:auth_helper/auth_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/core/pages/authentication/create_account_page.dart';

class VerifyPhoneNumber extends StatefulHookConsumerWidget {
  final bool islast;

  const VerifyPhoneNumber({Key? key, this.islast = false}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends ConsumerState<VerifyPhoneNumber> {
  final TextEditingController pinTextEditingController = TextEditingController();
  Timer? timer;
  String? codeMessage;
  Duration? validationTimeCode;
  late final AuthenticationPageThemeData theme;

  @override
  void initState() {
    timer?.cancel();
    validationTimeCode = const Duration(seconds: 120);
    theme = loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (validationTimeCode != null) {
        setState(() {
          validationTimeCode = validationTimeCode! - const Duration(seconds: 1);
        });
        if (validationTimeCode!.inSeconds == 0) {
          timer.cancel();
        }
      }
    });
    super.initState();
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: theme.checkCodeOtpTitleWidthConstraint ?? execInCaseOfPlatfom(() => 200, () => 232.w)),
            child: Text(
              "authentication.create-account.enter-code".tr(),
              style: (theme.titleOtpStyle ??
                  theme.titleStyle ??
                  TextStyle(
                    fontSize: sp(22),
                    color: const Color(0xFF021C36),
                    fontWeight: FontWeight.w600,
                  )),
              textAlign: TextAlign.center,
            ),
          ),
          sh(17),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              "authentication.login-with-phone.expire".tr(namedArgs: {
                "time":
                    "${(validationTimeCode!.inMinutes).toString().padLeft(2, "0")}:${(validationTimeCode!.inSeconds - ((validationTimeCode!.inMinutes * 60))).toString().padLeft(2, "0")}"
              }),
              style: (theme.subTitleStyle?.copyWith(fontSize: sp(14)) ??
                  TextStyle(
                    fontSize: sp(14),
                    color: const Color(0xFF021C36).withOpacity(.5),
                    fontWeight: FontWeight.w600,
                  )),
              textAlign: TextAlign.center,
            ),
          ),
          sh(
            theme.codeOtpTopSpacing ?? 28,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "field.phone.code-title".tr(),
                  style: (theme.codeTitleStyle ??
                          theme.titleStyle ??
                          TextStyle(
                            fontSize: sp(14),
                            color: const Color(0xFF021C36),
                            fontWeight: FontWeight.w600,
                          ))
                      .copyWith(fontSize: sp(14)),
                  textAlign: theme.codeAlignment ?? TextAlign.start,
                ),
              ],
            ),
          ),
          sh(6),
          PinCodeTextField(
            appContext: context,
            textStyle: theme.verifyNumberStyle ?? TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: sp(20)),
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: theme.verifyNumberStyle,
            length: 6,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            validator: (v) {
              if ((v?.length ?? 0) < 6) {
                return "Le code n’est pas complet";
              } else {
                printInDebug(v);
                codeMessage = v;
                return null;
              }
            },
            pinTheme: PinTheme(
              errorBorderColor: Colors.red,
              inactiveFillColor: theme.verifyNumberBox ?? const Color(0XFFF6F6F6),
              inactiveColor: theme.verifyNumberBox ?? const Color(0XFFF6F6F6),
              activeColor: theme.verifyNumberBox ?? const Color(0XFFF6F6F6),
              selectedFillColor: theme.verifyNumberBox ?? const Color(0XFFF6F6F6),
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(7),
              fieldHeight: formatHeight(47),
              fieldWidth: formatWidth(47),
              activeFillColor: theme.verifyNumberBox ?? Colors.white,
            ),
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            controller: pinTextEditingController,
            keyboardType: TextInputType.number,
            onCompleted: (codeVerification) async {
              //TODO
            },
            onChanged: (value) {
              printInDebug(value);
              codeMessage = value;
            },
            beforeTextPaste: (text) {
              printInDebug("Allowing to paste $text");
              return true;
            },
          ),
          sh(
            20,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "field.phone.not-received".tr(),
                    style: theme.richTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36).withOpacity(.35),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: "utils.resend".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await AuthService.verifPhoneNumberAndGetCredential(
                          phone: ref.read(createAccountProvider).phone!.phoneNumber!,
                          connexionDone: () {},
                          verificationFailed: (e) {
                            printInDebug("[Error]: $e");
                            NotifBanner.showToast(
                              context: context,
                              fToast: FToast().init(context),
                              title: "Erreur",
                              subTitle: "utils.error-occurred".tr(),
                            );
                          },
                          verificationError: (e) {
                            printInDebug("[Error]: $e");
                            NotifBanner.showToast(
                              context: context,
                              fToast: FToast().init(context),
                              title: "Erreur",
                              subTitle: "utils.error-occurred".tr(),
                            );
                          },
                          codeSent: (_, __) {
                            printInDebug("Code Sent");
                            printInDebug(_);
                            printInDebug(__);
                            ref.read(createAccountProvider).setSmsProvider(_);
                            timer?.cancel();
                            validationTimeCode = const Duration(seconds: 120);
                            timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                              if (validationTimeCode != null) {
                                setState(() {
                                  validationTimeCode = validationTimeCode! - const Duration(seconds: 1);
                                });
                                if (validationTimeCode!.inSeconds == 0) {
                                  timer.cancel();
                                }
                              }
                            });
                          },
                          redirectAfterTimeOut: (_) {},
                          setLoading: () {},
                          fToast: FToast().init(context),
                          context: context,
                        );
                      },
                    style: theme.cliquableTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ],
              ),
            ),
          ),
          sh(44),
          CTA.primary(
            isEnabled: ref.watch(createAccountProvider).phoneValidationId != null,
            textButton: "utils.connexion".tr(),
            onTap: () async {
              await _tryLoggin(context, ref);
            },
          ),
        ],
      ),
    );
  }

  _tryLoggin(BuildContext context, WidgetRef ref) async {
    var phoneProvider = ref.read(createAccountProvider).phoneValidationId;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: phoneProvider!, smsCode: codeMessage!);
    try {
      final UserCredential uc = await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      NotifBanner.showToast(
        context: context,
        fToast: FToast().init(context),
        title: "Erreur",
        subTitle: "authentication.phone.error-incorrect".tr(),
      );
      pinTextEditingController.clear();
      return;
    }

    AuthCredential emailCredential = EmailAuthProvider.credential(
      email: ref.read(createAccountProvider).email!,
      password: ref.read(createAccountProvider).password!,
    );
    await FirebaseAuth.instance.currentUser!.linkWithCredential(emailCredential);

    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).set({
      "verifiedPhone": true,
      "email": ref.read(createAccountProvider).email!,
      "phone": ref.read(createAccountProvider).phone!.phoneNumber!,
      "cguAccepted": true,
      "profilCompleted": false,
      "createdAt": Timestamp.now(),
    });
    if (getResponsiveValue(context, defaultValue: true, phone: false, tablet: false)) {
      ref.read(createAccountProvider).updatePage(ref.read(createAccountProvider).actualPage + 1);
    } else {
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
    }
  }
}
