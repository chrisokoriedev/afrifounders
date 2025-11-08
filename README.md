# Item Manager - Flutter App

A Flutter application for item management with CRUD operations, built using Clean Architecture, Riverpod, Freezed, and Hive.

## 📋 Project Overview

This app demonstrates a production-ready Flutter application following Clean Architecture principles. It allows users to create, read, update, and delete items with local persistence using Hive.

### Architecture Principles

- **Dependency Rule**: Dependencies flow inward (Presentation → Domain ← Data)
- **Domain Layer**: Pure Dart, no external dependencies
- **Data Layer**: Implements domain interfaces
- **Presentation Layer**: Uses Riverpod for state management

## 🛠️ Technologies Used

### State Management
- **Riverpod 3** with code generation (`@riverpod` annotations)
- Type-safe, compile-time checked providers

### Data Persistence
- **Hive**: Fast, lightweight NoSQL database
- Local storage with type-safe adapters

### Data Classes
- **Freezed**: Immutable data classes with union types
- Code generation for boilerplate reduction

### UI/UX
- **Material 3** design system
- **Google Fonts** (Inter)
- Light/Dark theme support
- **flutter_slidable** for swipe-to-delete

### Error Handling
- **dartz**: Functional programming (Either pattern)
- Custom Failure classes for error handling

## ✨ Key Features

- ✅ **CRUD Operations**: Create, Read, Update, Delete items
- ✅ **Local Persistence**: Data persists using Hive
- ✅ **Swipe to Delete**: Intuitive gesture-based deletion
- ✅ **Theme Toggle**: Light/Dark mode with persistence
- ✅ **Form Validation**: Input validation for item creation/editing
- ✅ **Error Handling**: User-friendly error messages with retry
- ✅ **Loading States**: Proper loading indicators
- ✅ **Empty States**: Helpful messages when no items exist

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd afrifounders
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Freezed, Riverpod, Hive)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

