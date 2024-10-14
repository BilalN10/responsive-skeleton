import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

/// Page template pour changer son mot de passe.
///
/// {@category Page}
/// {@category Core}
class ForgotPasswordPage extends StatefulHookConsumerWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  GlobalKey<FormState> key = GlobalKey();
  FocusNode node = FocusNode();
  TextEditingController controller = TextEditingController();
  final fToast = FToast();

  final appModel = GetIt.instance<ApplicationDataModel>();
  late final theme = loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    node.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = loadThemeData(null, "skeleton_authentication_scaffold_color", () => Theme.of(context).scaffoldBackgroundColor)!;

    if (appModel.applicationConfig.appBarOnAuthenticationPage) {
      return ScaffoldWithLogo.withBar(
        showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
        color: color,
        child: getResponsiveValue(
          context,
          defaultValue: Center(
            child: CustomCard(
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
      child: getResponsiveValue(
        context,
        defaultValue: Center(
          child: CustomCard(
            maxWidth: theme.formWidth ?? formatWidth(536),
            child: _buildLoginForm(context, theme),
          ),
        ),
        phone: _buildLoginForm(context, theme),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthenticationPageThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 294),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "authentication.forgot-password.title".tr(),
                    style: (theme.titleStyle ??
                        TextStyle(
                          fontSize: sp(22),
                          color: const Color(0xFF021C36),
                          fontWeight: FontWeight.w600,
                        )),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Text(
            "authentication.reset-password.subtitle".tr(),
            style: (theme.subTitleStyle ??
                TextStyle(
                  fontSize: sp(16),
                  color: const Color(0xFF021C36).withOpacity(.5),
                  fontWeight: FontWeight.w400,
                )),
            textAlign: TextAlign.center,
          ),
          sh(13),
          SizedBox(
            width: formatWidth(400),
            child: FormGenerator.generateForm(
              context,
              nodes: [node],
              controllers: [controller],
              fields: [
                FieldFormModel(
                  tag: "forgot-password",
                  type: FormFieldType.email,
                  fieldName: "field.email.title".tr(),
                  placeholder: "field.email.hint".tr(),
                ),
              ],
            ),
          ),
          sh(39),
          Center(
            child: CTA.primary(
              textButton: "authentication.forgot-password-link".tr(),
              onTap: () async {
                await _forgotPassword();
              },
            ),
          ),
        ],
      ),
    );
  }

  _forgotPassword() async {
    final emailValid = AuthValidator.validEmail(controller.text);
    if (emailValid != null) {
      NotifBanner.showToast(context: context, fToast: fToast, subTitle: emailValid.tr());
      return;
    }
    final rep = await AuthService.sendResetPasswordEmail(controller.text);
    if (rep != null) {
      NotifBanner.showToast(context: context, fToast: fToast, subTitle: "field.firebase.error".tr());
      return;
    } else {
      Alert.show(
        context: context,
        radius: theme.popupRadius ?? 10,
        title: "authentication.reset-password.title".tr(),
        content: "authentication.reset-password.content".tr(),
        defaultActionText: "close".tr(),
      );
      if (AutoRouter.of(context).canNavigateBack) {
        AutoRouter.of(context).navigateBack();
      } else {
        AutoRouter.of(context).navigateNamed("/login");
      }
    }
  }
}
