import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MobilePageView extends StatefulHookConsumerWidget {
  final List<Widget> pages;
  final PageController pageController;

  final ScrollPhysics? physics;

  /// BottomBar
  final Widget? bottomBar;
  final Widget Function(BuildContext, WidgetRef, int)? bottomBarBuilder;
  final List<bool>? bottomBarIsVisibleOnPage;

  /// AppBar
  final Widget? appBar;
  final Widget Function(BuildContext, WidgetRef, int)? appBarBuilder;
  final List<bool>? appBarIsVisibleOnPage;

  const MobilePageView({
    Key? key,
    required this.pages,
    required this.pageController,
    this.physics,
    this.bottomBar,
    this.bottomBarBuilder,
    this.bottomBarIsVisibleOnPage,
    this.appBar,
    this.appBarBuilder,
    this.appBarIsVisibleOnPage,
  }) : super(key: key);

  @override
  ConsumerState<MobilePageView> createState() => MobilePageViewState();
}

class MobilePageViewState extends ConsumerState<MobilePageView> {
  int page = 0;

  @override
  void initState() {
    page = widget.pageController.initialPage;
    widget.pageController.addListener(() {
      // setState(() {
      //   if (mounted) {
      //     page = widget.pageController.page!.round();
      //   }
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildAppBar(context),
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: PageView(
              physics: widget.physics ?? const NeverScrollableScrollPhysics(),
              controller: widget.pageController,
              children: widget.pages,
            ),
          ),
        ),
        _buildBottomBar(context),
      ],
    );
  }

  _buildBottomBar(BuildContext context) {
    if (widget.pageController.hasClients) {
      if (widget.bottomBarIsVisibleOnPage != null && widget.bottomBarIsVisibleOnPage!.length >= page) {
        if (!widget.bottomBarIsVisibleOnPage![page]) {
          return Container();
        }
      }
    }
    if (widget.bottomBar != null) {
      return widget.bottomBar!;
    } else if (widget.bottomBarBuilder != null) {
      return widget.bottomBarBuilder!(context, ref, page);
    } else {
      return const SizedBox();
    }
  }

  _buildAppBar(BuildContext context) {
    if (widget.appBarIsVisibleOnPage != null && widget.pageController.hasClients && widget.appBarIsVisibleOnPage!.length > page) {
      if (!widget.appBarIsVisibleOnPage![page]) {
        return Container();
      }
    }
    if (widget.appBar != null) {
      return widget.appBar!;
    } else if (widget.appBarBuilder != null) {
      return widget.appBarBuilder!(context, ref, page);
    } else {
      return const SizedBox();
    }
  }
}
