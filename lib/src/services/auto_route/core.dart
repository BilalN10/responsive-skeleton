import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

bool isRouteActive(BuildContext context, String routeName) => AutoRouter.of(context).current.name == routeName || isRouteActiveInParent(routeName, AutoRouter.of(context).current);

bool isRouteActiveInParent(String routeName, RouteData? data) => data?.name == routeName
    ? true
    : data?.parent != null
        ? isRouteActiveInParent(routeName, data?.parent)
        : false;

bool canNavigateBack(BuildContext context) => AutoRouter.of(context).canNavigateBack;
