# ***Creér une application***

#### Mobile

Voir l'exemple ci-dessous:

```Dart
    final appModel = ApplicationDataModel<T extends UserModel>(
        /// Toutes les configurations de votre application
        /// voir la documentation de [ApplicaitonDataModel].
        /// Vous n'êtes pas obligé de fournir les firebases options.
    );
    
    final appThemeInitializer = (BuildContext _) {
        final appTheme = AppTheme(
            appTheme: ThemeData(),
        );
        
        appTheme.addTheme("name", 
            FooThemeData(
                /// theme custom
            ),
        );
        
        /// Pour voir la liste des thèmes, merci d'ouvrir la documentation de [AppTheme].
        
        return appTheme;
    }

    await LaunchApplication.launch(
        applicationModel: appModel,
        appRouter: AppRouter(
            /// Guards...
        ),
        initTheme: appThemeInitializer,
    );
```

#### Web

Voir l'exemple ci-dessous:

```Dart
    final appModel = ApplicationDataModel<T extends UserModel>(
        /// Toutes les configurations de votre application
        /// voir la documentation de [ApplicaitonDataModel].
        /// Vous êtes obligé de fournir les firebases options.
    );
    
    final appThemeInitializer = (BuildContext _) {
        final appTheme = AppTheme(
            appTheme: ThemeData(),
        );
        
        appTheme.addTheme("name", 
            FooThemeData(
                /// theme custom
            ),
        );
        
        /// Pour voir la liste des thèmes, merci d'ouvrir la documentation de [AppTheme].
        
        return appTheme;
    }

    await LaunchApplication.launch(
        applicationModel: appModel,
        appRouter: AppRouter(
            /// Guards...
        ),
        initTheme: appThemeInitializer,
    );
```

# ***Liste des thèmes custom***

#### Skeleton :

```Dart
    appTheme.addTheme("skeleton_navbar_item", [LinkItemThemeData]);
    appTheme.addTheme("skeleton_appbar_item", [LinkItemThemeData]);
    appTheme.addTheme("skeleton_bottombar_item", [LinkItemThemeData]);
    
    appTheme.addTheme<double>("skeleton_logo_width", [double]);
    appTheme.addTheme<double>("skeleton_logo_width_in_appbar", [double]);
    
    appTheme.addTheme("skeleton_page_padding", [EdgeInsetsGGeometry]);
    appTheme.addTheme("skeleton_page_padding_tablet", [EdgeInsetsGGeometry]);
    appTheme.addTheme("skeleton_page_padding_phone", [EdgeInsetsGGeometry]);
    
    appTheme.addTheme<double>("skeleton_icon_size_web_width", [double]);
    appTheme.addTheme<double>("skeleton_icon_size_phone_width", [double]);
    
    appTheme.addTheme("skeleton_authentication_scaffold_color", [Color]);
```

#### Package :

Merci de voir directement la documentation des packages.