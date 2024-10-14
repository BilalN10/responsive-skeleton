import 'package:auto_route/auto_route.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/core/pages/authentication/create_account/verify_phone.dart';

final createAccountProvider = ChangeNotifierProvider<CreateAccountProvider>((ref) => CreateAccountProvider(ref));

/// Template affichant une page permettant de créer son profil.
///
/// {@category Page}
/// {@category Core}
class CreateAccountPage extends StatefulHookConsumerWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  GlobalKey<FormState> key = GlobalKey();

  final fToast = FToast();
  final appModel = GetIt.instance<ApplicationDataModel>();

  @override
  void initState() {
    super.initState();
    ref.read(createAccountProvider).init(0);
    fToast.init(context);
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
        showBackButton: false,
        child: getResponsiveValue(
          context,
          defaultValue: Center(
            child: CustomCard(
              maxWidth: theme.formWidth ?? formatWidth(536),
              useIntrisict: false,
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
        if (ref.read(createAccountProvider).controller.hasClients &&
            ref.read(createAccountProvider).controller.page! > 0) {
          ref
              .read(createAccountProvider)
              .controller
              .previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        } else {
          AutoRouter.of(context).canNavigateBack
              ? AutoRouter.of(context).navigateBack()
              : AutoRouter.of(context).replaceNamed("/");
        }
      },
      child: getResponsiveValue(
        context,
        defaultValue: Center(
          child: CustomCard(
            maxWidth: theme.formWidth ?? formatWidth(536),
            useIntrisict: false,
            child: _buildLoginForm(context, theme),
          ),
        ),
        phone: _buildLoginForm(context, theme, true),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthenticationPageThemeData theme, [bool isMobileSize = false]) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Padding(
        padding: (isMobileSize)
            ? EdgeInsets.only(
                top: theme.topTitleSpacing ?? (MediaQuery.of(context).padding.top + formatHeight(30)),
              )
            : EdgeInsets.zero,
        child: ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: ref.read(createAccountProvider).controller,
          children: [
            PrincipalData(
              cguContentBuilder: appModel.applicationConfig.cguContentBuilder,
              isLoginById: appModel.applicationConfig.typeOfLogin == LoginType.id,
              createAccount: getResponsiveValue(context, defaultValue: false, phone: true, tablet: true) &&
                  appModel.applicationConfig.createAccountNeedPhone == false,
              isLast: (getResponsiveValue(context, defaultValue: false, phone: true, tablet: true) &&
                  appModel.applicationConfig.createAccountNeedPhone == false),
            ),
            if (getResponsiveValue(context, defaultValue: true, phone: false, tablet: false))
              CgvuPage(
                cgu: appModel.applicationConfig.cguContent,
                createAccount: appModel.applicationConfig.createAccountNeedPhone == false,
                isLast: getResponsiveValue(context, defaultValue: true, phone: false, tablet: false) &&
                    appModel.applicationConfig.createAccountNeedPhone == false,
              ),
            if (appModel.applicationConfig.createAccountNeedPhone)
              VerifyPhoneNumber(islast: getResponsiveValue(context, defaultValue: false, phone: true, tablet: true)),
            if (getResponsiveValue(context, defaultValue: true, phone: false, tablet: false))
              const VerificationEmailSendPage(),
          ],
        ),
      ),
    );
  }
}
