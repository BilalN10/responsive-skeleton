import 'dart:async';
import 'dart:developer';

import 'package:auth_helper/auth_helper.dart';
import 'package:auto_route/auto_route.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart' as ph;

class LoginWithPhonePage extends StatefulHookConsumerWidget {
  const LoginWithPhonePage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginWithPhonePage> createState() => _LoginWithPhonePageState();
}

class _LoginWithPhonePageState extends ConsumerState<LoginWithPhonePage> {
  GlobalKey<FormState> key = GlobalKey();
  GlobalKey<FormState> phoneKey = GlobalKey();
  final fToast = FToast();
  PhoneNumber? phone;
  final appModel = GetIt.instance<ApplicationDataModel>();
  final PageController pageController = PageController();
  String? codeMessage;
  String? validCode;
  Duration? validationTimeCode;
  Timer? timer;
  late PhoneNumber _initialPhoneNumber;
  TextEditingController pinTextEditingController = TextEditingController();

  @override
  void initState() {
    fToast.init(context);
    _initialPhoneNumber = PhoneNumber(isoCode: "FR");
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color =
        loadThemeData(null, "skeleton_authentication_scaffold_color", () => Theme.of(context).scaffoldBackgroundColor)!;
    final theme = loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;

    if (appModel.applicationConfig.appBarOnAuthenticationPage) {
      return ScaffoldWithLogo.withBar(
        showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
        color: color,
        child: getResponsiveValue(
          context,
          defaultValue: Center(
            child: CustomCard(
              useIntrisict: false,
              maxWidth: theme.formWidth ?? formatWidth(536),
              child: _buildLoginForm(context, theme),
            ),
          ),
          phone: _buildLoginForm(context, theme),
        ),
      );
    }

    return ScaffoldWithLogo(
      showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
      color: color,
      showBackButton: true,
      onBackButtonPressed: () {
        if (!pageController.hasClients) {
          AutoRouter.of(context).navigateBack();
          return;
        }
        if (pageController.page == 0) {
          AutoRouter.of(context).navigateBack();
        } else {
          pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: getResponsiveValue(
        context,
        defaultValue: Center(
          child: CustomCard(
            useIntrisict: false,
            maxWidth: theme.formWidth ?? formatWidth(536),
            child: _buildLoginForm(context, theme),
          ),
        ),
        phone: Center(child: _buildLoginForm(context, theme, true)),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthenticationPageThemeData theme, [bool isMobileSize = false]) {
    return Padding(
      padding: (isMobileSize)
          ? EdgeInsets.only(top: theme.topTitleSpacing ?? (MediaQuery.of(context).padding.top + formatHeight(30)))
          : EdgeInsets.zero,
      child: ExpandablePageView(
        controller: pageController,
        children: [
          _buildFirstForm(context, theme, isMobileSize),
          _buildVerifyNumber(
            context,
            theme,
          ),
        ],
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  _buildFirstForm(BuildContext context, AuthenticationPageThemeData theme, [bool isMobileSize = false]) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              "authentication.login-with-phone.login-title".tr(),
              style: (theme.titleStyle ??
                  TextStyle(
                    fontSize: sp(22),
                    color: const Color(0xFF021C36),
                    fontWeight: FontWeight.w600,
                  )),
              textAlign: TextAlign.center,
            ),
          ),
          sh(theme.titleSpacing ?? 28),
          Form(
            key: phoneKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormGenerator.generateField(
                  context,
                  FieldFormModel(
                    initialValue: _initialPhoneNumber,
                    tag: "phone",
                    suffix: "authentication.connect-by-email".tr(),
                    onTapSuffix: () => AutoRouter.of(context).replaceNamed("/login"),
                    type: FormFieldType.phone,
                    requiredForForm: false,
                    onChanged: (val) => phone = val,
                    validator: (val) {
                      if (val == null && (val! as String).isEmpty) return "field.form-validator.required-field".tr();
                      return null;
                    },
                    placeholder: ("field.phone.hint").tr(),
                    fieldName: ("field.phone.title").tr(),
                  ),
                ),
              ],
            ),
          ),
          sh(44),
          CTA.primary(
            textButton: "utils.connexion".tr(),
            onTap: () async {
              await _loginByPhone();
            },
          ),
          if (appModel.applicationConfig.enableCreateAccount) ...[
            sh(33),
            const SizedBox(width: 40, child: Divider(height: .5)),
            sh(26),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "authentication.no-account-yet".tr(),
                    style: theme.richTextNotHaveAccountStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36).withOpacity(.35),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: "authentication.create-account-now".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        AutoRouter.of(context).pushNamed("/create-account");
                      },
                    style: theme.cliquableNotHaveAccountTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ],
              ),
            )
          ],
          if (appModel.applicationConfig.enableNoConnexion) ...[
            sh(33),
            const SizedBox(width: 40, child: Divider(height: .5)),
            sh(26),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "authentication.no-need-connexion".tr(),
                    style: theme.richTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36).withOpacity(.35),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: "authentication.no-connexion-start-now".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => AutoRouter.of(context)
                          .pushAndPopUntil(appModel.noConnexionRoute ?? appModel.mainRoute, predicate: (_) => false),
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
            )
          ],
        ],
      ),
    );
  }

  _buildVerifyNumber(BuildContext context, AuthenticationPageThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: theme.checkCodeOtpTitleWidthConstraint ?? execInCaseOfPlatfom(() => 200, () => 280.w)),
            child: Text(
              "authentication.login-with-phone.enter-code".tr(),
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
          if (validationTimeCode != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                "authentication.login-with-phone.expire".tr(namedArgs: {
                  "time":
                      "${(validationTimeCode!.inMinutes).toString().padLeft(2, "0")}:${(validationTimeCode!.inSeconds - ((validationTimeCode!.inMinutes * 60))).toString().padLeft(2, "0")}"
                }),
                style: (theme.subTitleStyle ??
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
            controller: pinTextEditingController,
            textStyle:
                theme.codeTitleStyle ?? TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: sp(20)),
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.w400,
            ),
            length: 6,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            validator: (v) {
              if ((v?.length ?? 0) < 6) {
                return "Le code n’est pas complet";
              } else {
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
              fieldHeight: formatHeight(54),
              fieldWidth: formatWidth(50),
              activeFillColor: theme.verifyNumberBox ?? Colors.white,
            ),
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            onCompleted: (codeVerification) async {
              //TODO
            },
            onChanged: (value) {
              codeMessage = value;
            },
            beforeTextPaste: (text) {
              printInDebug("Allowing to paste $text");
              return true;
            },
          ),
          sh(20),
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
                          phone: phone!.phoneNumber!,
                          connexionDone: () {
                            AutoRouter.of(context)
                                .pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
                          },
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
                          codeSent: (String code, int? __) {
                            validCode = code;
                            validationTimeCode = const Duration(seconds: 120);
                            timer?.cancel();
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
                          redirectAfterTimeOut: () {
                            AutoRouter.of(context)
                                .pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
                          },
                          setLoading: () {
                            //TODO
                          },
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
            textButton: "utils.connexion".tr(),
            onTap: () async {
              await _tryLoggin();
            },
          ),
        ],
      ),
    );
  }

  _loginByPhone() async {
    log("log in by phone");
    if (phoneKey.currentState?.validate() ?? false) {
      if (!await ph.AuthService.phoneDoesExist(phone!.phoneNumber!)) {
        printInDebug(phone!.phoneNumber!);
        printInDebug(!await ph.AuthService.phoneDoesExist(phone!.phoneNumber!));
        NotifBanner.showToast(
            context: context,
            fToast: FToast().init(context),
            subTitle: "authentication.phone.error-phone-not-exist".tr());
        return;
      }
      pinTextEditingController = TextEditingController();
      await AuthService.verifPhoneNumberAndGetCredential(
        phone: phone!.phoneNumber!,
        connexionDone: () {
          AutoRouter.of(context).pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
        },
        codeSent: (String code, int? __) {
          validCode = code;
          validationTimeCode = const Duration(seconds: 120);
          timer?.cancel();
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
        redirectAfterTimeOut: () {
          AutoRouter.of(context).pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
        },
        setLoading: () {},
        verificationError: (_) {},
        verificationFailed: (_) {},
        fToast: FToast().init(context),
        context: context,
      );
      pageController.jumpToPage(1);
    }
  }

  _tryLoggin() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: validCode!, smsCode: codeMessage!);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      printInDebug(userCredential);
      if (userCredential.user != null) {
        AutoRouter.of(context).pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
      } else {
        NotifBanner.showToast(
            context: context, fToast: FToast().init(context), subTitle: "authentication.phone.error-incorrect".tr());
      }
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
  }
}
