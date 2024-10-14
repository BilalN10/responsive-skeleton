import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

class VerificationEmailSendPage extends StatelessWidget {
  final bool returnToLogin;

  const VerificationEmailSendPage({
    Key? key,
    this.returnToLogin = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            "authentication.confirm-email.title".tr(),
            style: (theme.titleStyle ??
                TextStyle(
                  fontSize: sp(22),
                  color: const Color(0xFF021C36),
                  fontWeight: FontWeight.w600,
                )),
            textAlign: TextAlign.center,
          ),
        ),
        sh(16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 310),
          child: Text(
            "authentication.create-account.receive-email-body".tr(namedArgs: {
              "mail": FirebaseAuth.instance.currentUser!.email!,
            }),
            style: (theme.subTitleStyle ??
                TextStyle(
                  fontSize: sp(16),
                  color: const Color(0xFF021C36).withOpacity(.5),
                  fontWeight: FontWeight.w400,
                )),
            textAlign: TextAlign.center,
          ),
        ),
        sh(46),
        CTA.primary(
          textButton: "utils.refresh".tr(),
          onTap: () async {
            await FirebaseAuth.instance.currentUser!.reload();
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              AutoRouter.of(context).pushAndPopUntil(GetIt.I<ApplicationDataModel>().mainRoute, predicate: (_) => false);
            } else {
              await FirebaseAuth.instance.signOut();
              AutoRouter.of(context).replaceNamed("/login");
            }
          },
        ),
      ],
    );
  }

  const factory VerificationEmailSendPage.mobile({
    bool? returnToLogin,
  }) = _MobileVerificationEmailPage;
}

class _MobileVerificationEmailPage extends VerificationEmailSendPage {
  const _MobileVerificationEmailPage({
    bool? returnToLogin,
  }) : super(returnToLogin: returnToLogin ?? true);

  @override
  Widget build(BuildContext context) {
    final theme = loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;

    return CustomCard(
      backgroundColor: theme.popupBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      verticalPadding: formatHeight(28),
      horizontalPadding: formatWidth(22),
      maxWidth: formatWidth(282),
      borderRadius: theme.popupRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close_rounded, color: theme.popupButtonCloseColor ?? const Color(0xFFCFD2D6), size: formatHeight(20)),
              ),
            ],
          ),
          sh(24),
          Text(
            "authentication.confirm-email.title".tr(),
            style: (theme.popupTitleStyle ??
                TextStyle(
                  fontSize: sp(22),
                  color: const Color(0xFF021C36),
                  fontWeight: FontWeight.w600,
                )),
            textAlign: TextAlign.center,
          ),
          sh(13),
          Text(
            "authentication.create-account.receive-email-body".tr(namedArgs: {
              "mail": FirebaseAuth.instance.currentUser!.email!,
            }),
            style: (theme.popupContentStyle ??
                TextStyle(
                  fontSize: sp(16),
                  color: const Color(0xFF021C36).withOpacity(.5),
                  fontWeight: FontWeight.w400,
                )),
            textAlign: TextAlign.center,
          ),
          sh(36),
          CTA.primary(
            width: formatWidth(150),
            textButton: "utils.close".tr(),
            onTap: () async {
              await FirebaseAuth.instance.currentUser!.reload();
              if (FirebaseAuth.instance.currentUser!.emailVerified || !GetIt.I<ApplicationDataModel>().applicationConfig.emailMustBeVerified) {
                Navigator.pop(context, true);
              } else {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context, false);
              }
            },
          ),
        ],
      ),
    );
  }
}
