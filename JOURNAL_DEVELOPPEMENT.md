# Journal de Développement - Pronote Ifran Mobile

## Introduction

Ce journal documente le développement de l'application mobile Flutter "Pronote Ifran", un système de gestion scolaire destiné aux étudiants, parents, enseignants et coordinateurs de l'établissement Ifran. L'application permet la gestion des emplois du temps, des présences, des notes et des communications entre les différents acteurs de l'école.

## Vue d'ensemble du projet

- **Technologie**: Flutter (Dart)
- **Plateforme**: Mobile (Android/iOS)
- **Fonctionnalités principales**:
  - Authentification des utilisateurs
  - Interface étudiant : page d'accueil et emploi du temps
  - Modèles de données : utilisateurs, étudiants, classes, séances, modules, présences, parents
  - Services API pour la communication avec le backend
  - Stockage local avec SQLite (sqflite)

## État actuel du développement

L'application est en phase de développement actif. Les fonctionnalités de base sont implémentées, avec un focus récent sur l'interface étudiant.

### Fonctionnalités implémentées

- **Écran de connexion** (`login_screen.dart`) : Authentification des utilisateurs
- **Page d'accueil commune** (`common_homepage.dart`) : Point d'entrée après connexion
- **Interface étudiant** :
  - Page d'accueil étudiant (`student_homepage.dart`)
  - Page d'emploi du temps étudiant (`student_schedule_page.dart`)
- **Modèles de données** :
  - Utilisateurs (`users.dart`)
  - Étudiants (`eleve.dart`)
  - Classes (`classes.dart`)
  - Séances (`seance.dart`)
  - Modules (`modules.dart`)
  - Présences (`presence.dart`)
  - Parents (`parent.dart`)
- **Helpers** : Classes utilitaires pour la gestion des données (eleves_helper.dart, classes_helper.dart, etc.)
- **Services** : API service pour les appels réseau (`api_service.dart`)

### Progrès récent (basé sur TODO.md)

Les tâches suivantes ont été récemment complétées :

- [x] Modifier SeancesPage pour accepter les paramètres userType, userName, userFirstName, userNiveau, userSpecialite
- [x] Ajouter la propriété drawer au Scaffold de SeancesPage avec la logique pour 'Etudiant'
- [x] Mettre à jour la navigation dans CommonHomepage pour passer les paramètres à SeancesPage
- [x] Tester la navigation et la fonctionnalité du drawer
- [x] Filtrer les séances par classe de l'étudiant

Ces modifications permettent une meilleure personnalisation de l'interface étudiant, avec un tiroir de navigation et un filtrage des séances basé sur la classe de l'étudiant connecté.

## Prochaines étapes

- Implémenter les interfaces pour les autres types d'utilisateurs (parents, enseignants, coordinateurs)
- Ajouter la gestion des présences
- Intégrer les notifications push
- Améliorer l'interface utilisateur et l'expérience utilisateur
- Tests unitaires et d'intégration

## Notes techniques

- Utilisation de `flutter_secure_storage` pour le stockage sécurisé des tokens d'authentification
- API HTTP avec le package `http`
- Base de données locale SQLite avec `sqflite`
- Gestion des dates avec `intl`

---

*Dernière mise à jour : [Date actuelle]*
