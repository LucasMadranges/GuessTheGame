# Forum Mobile

Membres du projet: Lucas Madranges et Paul Pruvost

Description du projet:
Application mobile de forum réalisée en Flutter, conçue pour smartphones et tablettes (portrait/paysage). L'application suit une architecture Clean (Domain, Data, Presentation) avec un pattern MVVM. Les données (messages du forum et articles de blog) sont stockées localement dans de simples fichiers JSON.

Fonctionnalités principales:
- Accueil avec navigation.
- Lecture des messages du forum avec gestion des états de chargement, recherche et filtrage par auteur.
- Envoi de message avec gestion d'erreur simulée (affichage d'un message d'erreur et possibilité de réessayer).
- Blog (lecture de posts) avec gestion des états de chargement.
- Interface responsive adaptée au mode portrait et paysage (NavigationRail en paysage, BottomNavigationBar en portrait).

Architecture:
- Domain: entités, interfaces de dépôts, cas d'utilisation.
- Data: implémentations des dépôts, accès aux fichiers JSON locaux.
- Presentation: ViewModels (ChangeNotifier) et écrans (UI Flutter).

Plateformes supportées:
- Android uniquement. iOS n’est pas supporté dans ce dépôt (CocoaPods désactivé et non requis).

Démarrage:
- Installer Flutter et un émulateur/appareil Android.
- Depuis le dossier `mobile`: `flutter pub get` puis exécuter sur un device Android (ex: `flutter run -d android`).

Remarque sur iOS:
- Afin de retirer toute dépendance à CocoaPods, l’intégration iOS via Pods a été désactivée. Le fichier `ios/Podfile` est un simple stub et ne doit pas être utilisé. Si vous souhaitez cibler iOS, il faudra réactiver CocoaPods (ou supprimer/ignorer le répertoire `ios` et recréer un projet iOS compatible CocoaPods), puis réintroduire les plugins nécessaires.
