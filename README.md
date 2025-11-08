# Item Manager - Flutter App

A Flutter application for item management with CRUD operations, built using Clean Architecture, Riverpod, Freezed, and Hive.

## 📋 Project Overview

This app demonstrates a production-ready Flutter application following Clean Architecture principles. It allows users to create, read, update, and delete items with local persistence using Hive.

## 🏗️ Architecture

The project follows **Clean Architecture** with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App-wide constants (colors, strings, dimensions)
│   ├── error/              # Error handling (Failures)
│   ├── theme/             # App theming (Material 3)
│   └── utils/              # Utilities (validators)
│
├── shared/                 # Shared components
│   ├── providers/          # Shared providers (theme)
│   └── widgets/            # Reusable widgets
│
└── features/
    └── item_management/    # Main feature
        ├── data/           # Data layer
        │   ├── datasources/    # Local data source (Hive)
        │   ├── models/         # Data models
        │   └── repositories/   # Repository implementations
        │
        ├── domain/         # Domain layer (Business Logic)
        │   ├── entities/       # Business entities (Freezed)
        │   ├── repositories/   # Repository interfaces
        │   └── usecases/       # Use cases
        │
        └── presentation/    # Presentation layer
            ├── pages/          # Screens
            ├── providers/      # Riverpod providers
            ├── state/          # State classes
            └── widgets/        # Feature-specific widgets
```

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
- ✅ **Material 3**: Modern Material Design 3 components

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

## 📦 Dependencies

### Main Dependencies
- `flutter_riverpod`: State management
- `riverpod_annotation`: Riverpod code generation
- `hive` & `hive_flutter`: Local storage
- `freezed_annotation`: Immutable data classes
- `uuid`: Unique ID generation
- `dartz`: Functional programming (Either)
- `equatable`: Value equality
- `flutter_slidable`: Swipe actions
- `google_fonts`: Custom fonts

### Dev Dependencies
- `build_runner`: Code generation tool
- `freezed`: Freezed code generator
- `riverpod_generator`: Riverpod code generator
- `hive_generator`: Hive adapter generator
- `json_serializable`: JSON serialization

## 🎨 UI Components

### Shared Widgets
- `CustomTextField`: Styled input with validation
- `CustomButton`: Button with loading state
- `LoadingWidget`: Loading indicator
- `ErrorDisplayWidget`: Error message with retry
- `EmptyListWidget`: Empty state display

### Feature Widgets
- `ItemListTile`: Item display with checkbox and swipe actions
- `AddEditItemPage`: Form for creating/editing items
- `HomePage`: Main screen with item list

## 🔄 State Management Flow

1. **UI Layer** watches Riverpod providers
2. **Notifier** handles business logic and calls use cases
3. **Use Cases** execute business rules
4. **Repository** implements data operations
5. **Data Source** (Hive) persists data locally

## 📝 Code Generation

After making changes to:
- Freezed models (`@freezed`)
- Riverpod providers (`@riverpod`)
- Hive models (`@HiveType`)

Run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For watch mode (auto-regenerate):
```bash
flutter pub run build_runner watch
```

## 🧪 Testing

The project structure supports:
- **Unit Tests**: Test use cases and repositories
- **Widget Tests**: Test UI components
- **Integration Tests**: Test full user flows

## 📱 Screenshots

_(Add screenshots here)_

## 🔮 Future Enhancements

- [ ] Search and filter functionality
- [ ] Categories/Tags for items
- [ ] Item sorting options
- [ ] Cloud sync capability
- [ ] Export/Import functionality
- [ ] Item attachments/images

## 📄 License

This project is for assessment purposes.

## 👤 Author

Flutter Developer Assessment Project

---

**Note**: This project demonstrates Clean Architecture, modern Flutter practices, and best practices for state management and data persistence.
