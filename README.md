# My Diary

📝 **My Diary** is a beautiful, privacy-first, open source journal & diary app designed for people who value simplicity, minimalism, and control over their personal data.

## 🌟 Key Features

- **Timeline journaling** – your life flows naturally, no folders or tabs
- **Dedicated tablet UI** – optimized layouts for iPad & Android tablets, making writing and reading more immersive
- **Fully customizable writing** – bold, lists, checkboxes, colors, 1300+ Google Fonts
- **Throwback memories** – see what you wrote on this day years ago
- **Photo memories** – add multiple photos per page with custom layout
- **Feelings & moods tracker** – 45+ emotions, history & calendar view
- **Multi-page entries** – perfect for novels, prompts, or daily notes
- **Tags, stars & search** – keep your story organized and easy to find
- **Privacy first** – PIN, FaceID, fingerprint lock; data stays on your device
- **Backup & sync** – private Google Drive sync & offline local export
- **Themes & customization** – 20+ color themes, dark/light mode, fonts & layouts
- **Export & share** – text, markdown, or full backups with attachments (images, audio, etc.)
- **My Diary Pro** (one-time purchase):
  - **Customize Backgrounds** – Personalize your writing space with themed backgrounds for enhanced focus & creativity
  - **Templates**– Create your own daily writing templates
  - **Relaxing Sounds** – Set the mood before you write or read
  - **Period Calendar** – Track your period and create related story entries
  - **Voice Journal** – Record and organize voice notes
  - **Markdown Export** – Export entries in markdown format, fully compatible with Obsidian, Notion, and other editors
  - **Writing Stats** – View word and character count for your story
  - **Pinned Notes** – Keep important entries at the top of your timeline for easy access
  - **Auto Backup** – Keep your stories safe with automatic Google Drive sync
- **Available in 20+ languages** – and fully open source for transparency

## ⚙️ Setup & Run

Before getting started, ensure you have the following tools:

- Java: 21 [(LTS)](https://www.oracle.com/java/technologies/java-se-support-roadmap.html) (for Android)
- Ruby: 3.3.5 (for IOS)
- Flutter: 3.29.0

> If you're using asdf, refer to this [guide](docs/development/setup_asdf.md). For more development documentation, see the [Development Guide](docs/development/). Otherwise, you can install above versions manually with fvm, rvm, rbenv or others.

### 🔥 Firebase Setup Required

This project requires Firebase for authentication and cloud features. You must create your own Firebase project and provide the configuration files:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com/)
2. Add an Android app with the package name `com.ravana.mydiary`
3. Add an iOS app with your bundle identifier
4. Download the config files and place them in your project:
   - Put `google-services.json` inside `android/app/`
   - Put `GoogleService-Info.plist` inside `ios/Runner/`

Once Firebase is configured, run the project with:

```s
flutter run --flavor community --dart-define-from-file=configs/community.json --target=lib/main_community.dart
```

## 🛠 Project Overview

My Diary is designed with simplicity in mind, both in its UI and codebase. We aimed to keep the code understandable while staying true to Flutter's principles.

### 1. State Management:

My Diary uses Provider and Stateful widgets to manage its state, distinctly organized into three levels to avoid confusion:

- Global State: Managed by [ProviderScope](lib/provider_scope.dart), disposed when the app closes.
- View State: Managed by ChangeNotifierProvider (package:provider/provider.dart), disposed when the page closes.
- Widget State: Managed by Stateful widgets, where the widget itself controls its own state and is disposed when removed from the tree.

### 2. MVVM Pattern:

My Diary leverages the MVVM (Model-View-ViewModel) pattern while each view is composed of three to four key files:

- Model (optional): Represents the data structure, e.g., StoryDbModel.
- View: Constructs the view model and builds the UI content, e.g., EditStoryView.
- ViewContent: Displays the actual UI, keeping the visual layout separate from business logic, e.g., EditStoryContent.
- ViewModel: Manages business logic, provides data & operations to the view, keeping the UI free from unnecessary logic, e.g., EditStoryViewModel.

[![MVVM with layers](docs/architecture/mvvm-intro-with-layers.png)](https://docs.flutter.dev/app-architecture/guide#mvvm)

### 3. Local Database:

My Diary uses ObjectBox as the local database solution for persistent data storage. ObjectBox provides fast, efficient, and scalable database operations with rich search capabilities, making it ideal for mobile apps that require high-performance data handling.

## 🤝 Learn & Contribute

Feel free to clone the repository and explore the code. It's a great resource for learning how to build efficient, maintainable mobile apps with Flutter. You can also contribute improvements or new features, helping enhance the project for everyone.

Check out our [Contribution Guide](CONTRIBUTING.md) for more details on how to contribute. Raise an issue if you need any support.

## 📄 License

Licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
