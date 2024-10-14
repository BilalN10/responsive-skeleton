import 'package:auto_route/auto_route.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ui_kosmos_v4/form/theme.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  GlobalKey<FormState> key = GlobalKey();
  final FocusNode _emailNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _passwordNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final fToast = FToast();

  final GlobalKey<FormState> resetPasswordKey = GlobalKey();

  final PanelController panelController = PanelController();
  String? resetEmail;

  final appModel = GetIt.instance<ApplicationDataModel>();

  late final AuthenticationPageThemeData theme;

  @override
  void initState() {
    theme = loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;
    ref.read(userChangeNotifierProvider).clear();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color =
        loadThemeData(null, "skeleton_authentication_scaffold_color", () => Theme.of(context).scaffoldBackgroundColor)!;

    if (appModel.applicationConfig.appBarOnAuthenticationPage && kIsWeb) {
      return ScaffoldWithLogo.withBar(
        showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
        color: color,
        showBackButton: false,
        child: getResponsiveValue(
          context,
          defaultValue: Center(
            child: CustomCard(
              maxWidth: theme.formWidth ?? formatWidth(536),
              child: _buildLoginForm(context, theme),
            ),
          ),
          phone: _buildLoginForm(context, theme, true),
        ),
      );
    }

    return ScaffoldWithLogo(
      showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
      color: color,
      showBackButton: AutoRouter.of(context).canNavigateBack,
      onBackButtonPressed: () {
        AutoRouter.of(context).navigateBack();
      },
      child: getResponsiveValue(
        context,
        defaultValue: Center(
          child: CustomCard(
            maxWidth: theme.formWidth ?? formatWidth(536),
            child: _buildLoginForm(context, theme),
          ),
        ),
        phone: _buildLoginForm(context, theme, true),
      ),
    );
  }

  _buildResetPasswordPhone(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(29.w, 16.h, 29.w, 39.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(55), topRight: Radius.circular(55)),
        color: theme.resetPasswordBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Form(
        key: resetPasswordKey,
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
            Text(
              "authentication.forgot-password.title".tr(),
              style: theme.titleStyle?.copyWith(fontSize: sp(17)) ??
                  TextStyle(
                    fontSize: sp(17),
                    color: const Color(0xFF021C36),
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            sh(17),
            Text(
              "authentication.reset-password.subtitle".tr(),
              style: theme.subTitleStyle ??
                  TextStyle(
                    fontSize: sp(14),
                    color: const Color(0xFFA7ADB5),
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            sh(35),
            TextFormUpdated.classic(
              fieldName: "Adresse email",
              hintText: "john.doe@gmail.com",
              onChanged: (val) => resetEmail = val,
              validator: (val) => AuthValidator.validEmail(val)?.tr(),
            ),
            sh(43),
            CTA.primary(
              textButton: "Réinitialiser",
              onTap: () async {
                if (resetPasswordKey.currentState?.validate() ?? false) {
                  printInDebug(resetEmail);
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmail!);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthenticationPageThemeData theme, [bool isMobileSize = false]) {
    final inputTheme =
        loadThemeData<CustomFormFieldThemeData>(null, "input_field", () => const CustomFormFieldThemeData());

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMobileSize)
            SizedBox(height: theme.topTitleSpacing ?? (MediaQuery.of(context).padding.top + formatHeight(30))),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: execInCaseOfPlatfom(
                    () => theme.titleParentWidth ?? 200, () => theme.titleParentWidth ?? formatWidth(232))),
            child: Text(
              "authentication.login.login-title".tr(),
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
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormUpdated.classic(
                  fieldName: "authentication.email.title".tr(),
                  hintText: "authentication.email.hint".tr(),
                  textInputType: TextInputType.emailAddress,
                  focusNode: _emailNode,
                  nextFocusNode: _passwordNode,
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  fieldPostRedirection: appModel.applicationConfig.enableConnexionWithPhone
                      ? "authentication.connect-by-phone".tr()
                      : null,
                  postFieldOnClick: () => appModel.applicationConfig.enableConnexionWithPhone
                      ? AutoRouter.of(context).navigateNamed("/login-with-phone")
                      : null,
                  validator: (p0) {
                    if (appModel.applicationConfig.typeOfLogin == LoginType.id) {
                      return (p0?.isEmpty ?? true) ? "error.field.cant-be-empty".tr() : null;
                    }
                    return AuthValidator.validEmail(p0)?.tr();
                  },
                ),
                sh(14),
                TextFormUpdated.classic(
                  fieldName: "authentication.password.title".tr(),
                  hintText: "authentication.password.hint".tr(),
                  textInputType: TextInputType.text,
                  focusNode: _passwordNode,
                  nextFocusNode: _passwordNode,
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  obscuringText: true,
                  isUpdatable: true,
                  suffixChild: Icon(Icons.remove_red_eye_outlined, color: inputTheme?.suffixIconColor),
                  suffixChildActive: Icon(Icons.remove_red_eye, color: inputTheme?.suffixIconColor),
                  validator: (p0) {
                    return (p0?.isEmpty ?? true) ? "error.field.cant-be-empty".tr() : null;
                  },
                ),
                sh(15),
              ],
            ),
          ),
          if (appModel.applicationConfig.enableForgotPassword) ...[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "authentication.forgot-password-message".tr(),
                    style: theme.richTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36).withOpacity(.35),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: "authentication.forgot-password-link".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        execInCaseOfPlatfom(
                          () => AutoRouter.of(context).replaceNamed("/forgot-password"),
                          () async => await showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(55), topRight: Radius.circular(55)),
                            ),
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildResetPasswordPhone(context),
                                sh(MediaQuery.of(context).viewInsets.bottom),
                              ],
                            ),
                          ),
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
          ],
          sh(44),
          CTA.primary(textButton: "utils.connexion".tr(), onTap: () async => await _login()),

          /// Show create account button if enabled
          if (appModel.applicationConfig.enableCreateAccount) ...[
            sh(33),
            const SizedBox(width: 40, child: Divider(height: .5)),
            sh(26),
            Center(
              child: RichText(
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
                          kIsWeb
                              ? AutoRouter.of(context).replaceNamed("/create-account")
                              : AutoRouter.of(context).navigateNamed("/create-account");
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
              ),
            )
          ],

          /// Show redirection button if enabled (only for no connexion)
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

  _login() async {
    if (!(key.currentState?.validate() ?? false)) return;
    final emailValue = _emailController.value.text.trim();
    final isEmail = AuthValidator.validEmail(emailValue) == null;

    final appModel = GetIt.I<ApplicationDataModel>();

    var email = emailValue;
    if (!isEmail && appModel.applicationConfig.typeOfLogin == LoginType.id) {
      final rep = await FirebaseFunctions.instance.httpsCallable("getEmailFromIdentifier").call({
        "identifier": emailValue,
      });
      if (rep.data["error"] != null) {
        NotifBanner.showToast(context: context, fToast: FToast().init(context), subTitle: rep.data["error"].tr());
        _passwordController.clear();
        _emailController.clear();
        return;
      }
      email = rep.data["email"];
    }

    final rep = await AuthService.signInWithEmail(email, _passwordController.text);
    if (rep.type == "error") {
      NotifBanner.showToast(context: context, fToast: FToast().init(context), subTitle: rep.message.tr());
      _passwordController.clear();
      return;
    }

    if (appModel.applicationConfig.onLoginSuccess != null) {
      final loginCallbackRep = await appModel.applicationConfig.onLoginSuccess!(context, rep);
      if (loginCallbackRep == true) {
        return;
      }
    }

    if (!FirebaseAuth.instance.currentUser!.emailVerified == true &&
        appModel.applicationConfig.emailMustBeVerified == true) {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      await FirebaseAuth.instance.signOut();
      _passwordController.clear();
      _emailController.clear();
      await execInCaseOfPlatfom(() {
        Alert.showWebDialog(
          context: context,
          title: "authentication.confirm-email.title".tr(),
          content: "authentication.confirm-email.must-validate-email".tr(),
          defaultActionText: "utils.close".tr(),
        );
      }, () {
        Alert.show(
          context: context,
          radius: theme.popupRadius ?? 10,
          title: "authentication.confirm-email.title".tr(),
          content: "authentication.confirm-email.must-validate-email".tr(),
          defaultActionText: "utils.close".tr(),
        );
      });
      return;
    }

    // TODO Version 4.0.0 : remove this and add a firebase listener inside User Provider to update change automaticly.
    await ref.read(userChangeNotifierProvider).init(FirebaseAuth.instance.currentUser!.uid, context);

    AutoRouter.of(context).pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
  }
}
