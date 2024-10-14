import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class PermissionPage extends StatefulHookConsumerWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends ConsumerState<PermissionPage> {
  final appModel = GetIt.I<ApplicationDataModel>();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = appModel.dependenciesConfiguration;
    final permissionWidget = appModel.applicationConfig.permissonWidgets ?? config.permissonWidgets;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: PermissionsPageViewCustom(
          pages: permissionWidget.map((e) => e(context, ref, _pageController)).toList(),
          pageController: _pageController,
        ),
      ),
    );
  }
}
