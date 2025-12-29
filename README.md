# WhatsApp Clone - Flutter Application

<div align="center">

A feature-rich, full-stack WhatsApp clone built with Flutter and Firebase, implementing real-time messaging, group chats, status updates, and comprehensive media sharing capabilities.

[![Flutter](https://img.shields.io/badge/Flutter-3.2.3+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-3.0.0-purple?style=for-the-badge)](https://riverpod.dev)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Firebase Configuration](#-firebase-configuration)
- [Dependencies](#-dependencies)
- [Feature Deep Dive](#-feature-deep-dive)
- [Data Models](#-data-models)
- [State Management](#-state-management)
- [Screenshots](#-screenshots)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

This WhatsApp clone is a comprehensive Flutter application that replicates core functionalities of WhatsApp, including:
- **Real-time one-on-one messaging** with text, images, videos, audio, and GIFs
- **Group chat functionality** with member management
- **Status/Stories feature** with 24-hour expiry
- **Phone number authentication** with OTP verification
- **Contact synchronization** from device
- **Online/offline status tracking**
- **Message reply functionality**
- **Cross-platform support** (iOS, Android, Web, Linux, macOS, Windows)

The app demonstrates modern Flutter development practices with clean architecture, proper state management using Riverpod, and Firebase backend integration.

---

## ✨ Features

### 🔐 Authentication
- **Phone Number Authentication**: OTP-based verification using Firebase Auth
- **User Profile Setup**: Upload profile picture and set display name
- **Persistent Sessions**: Auto-login for authenticated users
- **Secure Logout**: Clean session management

### 💬 Chat System
- **Real-time Messaging**: Instant message delivery and synchronization
- **Multiple Message Types**: 
  - Text messages
  - Image sharing
  - Video sharing
  - Audio messages
  - GIF support
- **Message Status**: Delivered and seen indicators
- **Reply to Messages**: Quote and reply functionality
- **Contact List**: View all conversations with last message preview
- **Online Status**: Real-time user presence tracking

### 👥 Group Features
- **Create Groups**: Select multiple contacts to create group chats
- **Group Profile**: Set group name and profile picture
- **Group Messaging**: All message types supported
- **Member List**: View all group participants
- **Group Broadcasts**: Messages visible to all members

### 📸 Status/Stories
- **Text Status**: Share text-based status updates
- **Photo/Video Status**: Share media with 24-hour visibility
- **GIF Status**: Share animated GIFs
- **Status Viewer**: View others' status updates
- **View List**: See who viewed your status
- **Auto Expiry**: Status automatically expires after 24 hours

### 📱 Additional Features
- **Responsive Design**: Separate layouts for mobile and web
- **Dark Theme**: WhatsApp-inspired dark mode
- **Media Caching**: Efficient image and video caching
- **Emoji Support**: Full emoji keyboard integration
- **File Permissions**: Handles camera, storage, and contacts permissions
- **Error Handling**: Comprehensive error messaging via Snackbars

---

## 🏗️ Architecture

The application follows a **clean architecture pattern** with clear separation of concerns:

```
┌─────────────────────────────────────────────────┐
│                  Presentation                    │
│  (Screens, Widgets, UI Components)              │
└───────────────────┬─────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────┐
│              State Management                    │
│         (Controllers, Providers)                 │
└───────────────────┬─────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────┐
│               Business Logic                     │
│              (Repositories)                      │
└───────────────────┬─────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────┐
│                Data Layer                        │
│    (Firebase, Models, Data Sources)              │
└─────────────────────────────────────────────────┘
```

### Architecture Layers:

1. **Presentation Layer** (`screens/`, `widgets/`): UI components and screens
2. **Controller Layer** (`controller/`): Business logic and state management
3. **Repository Layer** (`repository/`): Data access and API interactions
4. **Data Layer** (`models/`): Data models and entities

---

## 🛠️ Tech Stack

### **Core Framework**
- **Flutter 3.2.3+**: Cross-platform UI framework
- **Dart SDK**: Programming language

### **State Management**
- **Flutter Riverpod 3.0.0**: Reactive state management with providers
  - `Provider`: Dependency injection
  - `FutureProvider`: Async data fetching
  - `StreamProvider`: Real-time data streams
  - `ConsumerWidget`: Reactive UI components

### **Backend Services**
- **Firebase Core 2.24.2**: Firebase initialization
- **Firebase Authentication 4.15.3**: Phone number authentication with OTP
- **Cloud Firestore 4.13.6**: NoSQL database for real-time data
- **Firebase Storage 11.5.6**: Cloud storage for media files

### **Media Handling**
- **image_picker 1.0.5**: Camera and gallery access
- **cached_network_image 3.3.1**: Image caching and loading
- **cached_video_player 2.0.4**: Video playback with caching
- **flutter_sound 9.2.13**: Audio recording
- **audioplayers 5.2.1**: Audio playback

### **UI/UX Enhancements**
- **emoji_picker_flutter 1.6.3**: Emoji keyboard
- **enough_giphy_flutter 0.4.1**: GIF integration
- **swipe_to 1.0.5**: Swipe gestures for message reply
- **story_view 0.16.0**: Instagram-like story viewer
- **country_picker 2.0.23**: Country code selection for phone numbers

### **Utilities**
- **flutter_contacts 1.1.7**: Device contact synchronization
- **uuid 3.0.7**: Unique ID generation
- **intl 0.19.0**: Internationalization and date formatting
- **path_provider 2.1.1**: File system access
- **permission_handler 11.0.0**: Runtime permission handling
- **http 1.2.1**: HTTP requests

### **Development Tools**
- **flutter_lints 3.0.1**: Code quality and linting rules

---

## 📁 Project Structure

```
whatsapp_clone/
├── lib/
│   ├── main.dart                    # Application entry point
│   ├── router.dart                  # Route management
│   ├── colors.dart                  # Theme colors
│   ├── info.dart                    # Sample data
│   │
│   ├── common/                      # Shared utilities
│   │   ├── enums/
│   │   │   └── message_type.dart    # Message type enum
│   │   ├── repository/
│   │   │   └── file_upload_repository.dart
│   │   ├── screens/
│   │   │   └── error_screen.dart
│   │   ├── strings/                 # String constants
│   │   ├── typedefs/                # Type definitions
│   │   ├── utils/
│   │   │   └── utils.dart           # Helper functions
│   │   └── widgets/
│   │       ├── custom_button.dart
│   │       └── loader.dart
│   │
│   ├── features/                    # Feature modules
│   │   ├── auth/                    # Authentication
│   │   │   ├── controller/
│   │   │   │   └── auth_controller.dart
│   │   │   ├── repository/
│   │   │   │   ├── auth_repository.dart
│   │   │   │   └── is_loggedin_provider.dart
│   │   │   └── screens/
│   │   │       ├── landing_screen.dart
│   │   │       ├── login_screen.dart
│   │   │       ├── otp_screen.dart
│   │   │       └── user_information_screen.dart
│   │   │
│   │   ├── chat/                    # One-on-one chat
│   │   │   ├── controller/
│   │   │   │   └── chat_controller.dart
│   │   │   ├── repository/
│   │   │   │   └── chat_repository.dart
│   │   │   ├── screens/
│   │   │   │   └── mobile_chat_screen.dart
│   │   │   └── widgets/
│   │   │       ├── bottom_text_field.dart
│   │   │       ├── cached_video_widget.dart
│   │   │       ├── chat_list.dart
│   │   │       ├── display_message_or_file.dart
│   │   │       ├── message_card_reply_preview.dart
│   │   │       ├── message_reply_preview.dart
│   │   │       ├── my_message_card.dart
│   │   │       └── sender_message_card.dart
│   │   │
│   │   ├── groups/                  # Group chat
│   │   │   ├── controller/
│   │   │   │   └── group_controller.dart
│   │   │   ├── providers/
│   │   │   ├── repository/
│   │   │   │   └── group_repository.dart
│   │   │   ├── screens/
│   │   │   │   ├── create_group_screen.dart
│   │   │   │   └── group_chat_screen.dart
│   │   │   └── widgets/
│   │   │       └── groups_list.dart
│   │   │
│   │   ├── status/                  # Status/Stories
│   │   │   ├── controller/
│   │   │   │   └── status_controller.dart
│   │   │   ├── repository/
│   │   │   │   └── status_repository.dart
│   │   │   ├── screens/
│   │   │   │   ├── add_status_screen.dart
│   │   │   │   ├── show_status_list_screen.dart
│   │   │   │   └── show_status_screen.dart
│   │   │   └── widgets/
│   │   │
│   │   ├── select_contacts/         # Contact selection
│   │   │   ├── controller/
│   │   │   │   └── select_contacts_controller.dart
│   │   │   ├── repository/
│   │   │   │   └── select_contacts_repository.dart
│   │   │   └── screens/
│   │   │       └── select_contacts_screen.dart
│   │   │
│   │   ├── landing/                 # Landing page
│   │   │   └── screens/
│   │   │       └── landing_screen.dart
│   │   │
│   │   └── loading/                 # Loading overlay
│   │       ├── providers/
│   │       │   └── is_loading_provider.dart
│   │       └── screens/
│   │           └── loading_overlay.dart
│   │
│   ├── models/                      # Data models
│   │   ├── contact_chat.dart
│   │   ├── group_message_model.dart
│   │   ├── group_model.dart
│   │   ├── message_model.dart
│   │   ├── message_reply.dart
│   │   ├── status_model.dart
│   │   └── user_model.dart
│   │
│   ├── screens/                     # Main screens
│   │   ├── mobile_layout_screen.dart
│   │   └── web_layout_screen.dart
│   │
│   ├── utils/
│   │   └── responsive_layout.dart
│   │
│   └── widgets/                     # Shared widgets
│       ├── contacts_list.dart
│       ├── web_chat_appbar.dart
│       ├── web_profile_bar.dart
│       └── web_search_bar.dart
│
├── android/                         # Android configuration
│   └── app/
│       ├── google-services.json     # Firebase config (Android)
│       └── build.gradle
│
├── ios/                             # iOS configuration
│   └── Runner/
│       ├── GoogleService-Info.plist # Firebase config (iOS)
│       └── Info.plist
│
├── web/                             # Web configuration
├── linux/                           # Linux configuration
├── macos/                           # macOS configuration
├── windows/                         # Windows configuration
│
├── assets/                          # Static assets
│   ├── backgroundImage.png
│   └── bg.png
│
├── test/                            # Unit tests
│   └── widget_test.dart
│
├── pubspec.yaml                     # Dependencies
├── analysis_options.yaml            # Linting rules
└── README.md                        # This file
```

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- **Flutter SDK** (3.2.3 or higher)
- **Dart SDK** (>=3.2.3 <4.0.0)
- **Android Studio** / **Xcode** (for mobile development)
- **Firebase Account** (for backend services)
- **Git**

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/whatsapp_clone.git
   cd whatsapp_clone
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```
   Resolve any issues shown by `flutter doctor`.

4. **Configure Firebase** (see [Firebase Configuration](#-firebase-configuration))

5. **Run the application**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS:
   ```bash
   flutter run -d ios
   ```
   
   For Web:
   ```bash
   flutter run -d chrome
   ```

---

## 🔥 Firebase Configuration

This app requires Firebase for authentication, database, and storage. Follow these steps:

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project" and follow the wizard
3. Enable Google Analytics (optional)

### 2. Register Your Apps

#### **Android Setup**

1. In Firebase Console, click "Add app" → Android
2. Register app with package name: `com.example.whatsapp_clone` (or your package name)
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Ensure `google-services` plugin is in `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```
6. Apply plugin in `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### **iOS Setup**

1. In Firebase Console, click "Add app" → iOS
2. Register app with bundle ID from `ios/Runner/Info.plist`
3. Download `GoogleService-Info.plist`
4. Open Xcode, drag `GoogleService-Info.plist` into `Runner/Runner` directory
5. Ensure it's added to the target

#### **Web Setup**

1. In Firebase Console, click "Add app" → Web
2. Copy the Firebase config object
3. Add it to `web/index.html`

### 3. Enable Firebase Services

#### **Authentication**
1. Go to Authentication → Sign-in method
2. Enable "Phone" authentication
3. Add test phone numbers if needed during development

#### **Cloud Firestore**
1. Go to Firestore Database → Create Database
2. Start in **production mode** or **test mode**
3. Set up security rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /users/{userId}/chats/{chatId} {
         allow read, write: if request.auth != null;
       }
       match /groups/{groupId} {
         allow read, write: if request.auth != null;
       }
       match /status/{statusId} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == resource.data.userModel.uid;
       }
     }
   }
   ```

#### **Firebase Storage**
1. Go to Storage → Get Started
2. Set up storage rules:
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

### 4. Initialize Firebase in Flutter

The app uses `firebase_options.dart` for configuration. Generate it with:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will generate `lib/firebase_options.dart` automatically.

---

## 📦 Dependencies

### **Production Dependencies**

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^3.0.0-dev.3 | State management |
| `firebase_core` | ^2.24.2 | Firebase initialization |
| `firebase_auth` | ^4.15.3 | Authentication |
| `cloud_firestore` | ^4.13.6 | Database |
| `firebase_storage` | ^11.5.6 | File storage |
| `image_picker` | ^1.0.5 | Image/video selection |
| `cached_network_image` | ^3.3.1 | Image caching |
| `cached_video_player` | ^2.0.4 | Video playback |
| `flutter_contacts` | ^1.1.7 | Contact access |
| `country_picker` | ^2.0.23 | Country selection |
| `emoji_picker_flutter` | ^1.6.3 | Emoji keyboard |
| `enough_giphy_flutter` | ^0.4.1 | GIF picker |
| `flutter_sound` | ^9.2.13 | Audio recording |
| `audioplayers` | ^5.2.1 | Audio playback |
| `story_view` | ^0.16.0 | Story viewer |
| `swipe_to` | ^1.0.5 | Swipe gestures |
| `uuid` | ^3.0.7 | ID generation |
| `intl` | ^0.19.0 | Internationalization |
| `path_provider` | ^2.1.1 | File paths |
| `permission_handler` | ^11.0.0 | Permissions |
| `http` | ^1.2.1 | HTTP requests |
| `cupertino_icons` | ^1.0.2 | iOS icons |

### **Dev Dependencies**

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | sdk: flutter | Testing framework |
| `flutter_lints` | ^3.0.1 | Linting rules |

### Installing Dependencies

```bash
flutter pub get
```

---

## 🎯 Feature Deep Dive

### 1. Authentication System

**Flow:**
```
Landing Screen → Login Screen → OTP Screen → User Info Screen → Home Screen
```

**Components:**
- `AuthController`: Manages authentication state
- `AuthRepository`: Handles Firebase Auth API calls
- `isLoggedInProvider`: Tracks user login state

**Key Functions:**
- `signInWithPhoneNumber()`: Initiates phone authentication
- `verifyOTP()`: Validates OTP and signs in user
- `uploadUserDataToFirebase()`: Creates user profile
- `setUserOnlineState()`: Updates user's online status

**Firestore Structure:**
```
users/
  └── {userId}/
      ├── uid: String
      ├── name: String
      ├── phoneNumber: String
      ├── profilePic: String (URL)
      ├── isOnline: Boolean
      └── groupsId: Array<String>
```

### 2. Chat System

**One-on-One Chat Architecture:**

**Firestore Structure:**
```
users/
  └── {userId}/
      └── chats/
          └── {contactUserId}/
              ├── name: String
              ├── profilePic: String
              ├── lastMessage: String
              ├── lastMessageTime: Timestamp
              ├── isGroupChat: Boolean
              └── messages/
                  └── {messageId}/
                      ├── text: String
                      ├── time: Timestamp
                      ├── messageId: String
                      ├── isSeen: Boolean
                      ├── senderUserModel: Map
                      ├── receiverUserModel: Map
                      ├── messageType: String
                      └── messageReplyModel: Map
```

**Message Types:**
- `text`: Plain text messages
- `image`: Image files
- `video`: Video files
- `audio`: Voice messages
- `gif`: Animated GIFs

**Key Features:**
- Real-time message streaming using Firestore snapshots
- Message seen/unseen status
- Reply to specific messages
- Media upload to Firebase Storage
- Contact chat list with last message preview

**Controller Methods:**
- `sendMessage()`: Send text messages
- `sendFileMessage()`: Send media files
- `sendGIF()`: Send GIF messages
- `getChatMessages()`: Stream messages for a conversation
- `getContactChats()`: Get list of all conversations
- `setMessageSeen()`: Mark messages as read

### 3. Group Chat System

**Firestore Structure:**
```
groups/
  └── {groupId}/
      ├── groupId: String
      ├── groupName: String
      ├── groupProfilePic: String (URL)
      ├── groupMembersIds: Array<String>
      ├── lastMessageUserId: String
      ├── lastMessageUserName: String
      ├── lastMessageText: String
      ├── lastMessageTime: Timestamp
      └── messages/
          └── {messageId}/
              ├── messageId: String
              ├── text: String
              ├── time: Timestamp
              ├── messageUserId: String
              ├── messageUserName: String
              ├── messageType: String
              └── messageReplyModel: Map
```

**Group Features:**
- Create groups with multiple contacts
- Group profile picture upload
- All message types supported
- Member list visibility
- Group message broadcasting

**Controller Methods:**
- `createGroup()`: Create new group
- `getGroupModels()`: Stream all user's groups
- `sendMessage()`: Send text to group
- `sendFileMessage()`: Send media to group
- `sendGIF()`: Send GIF to group

### 4. Status/Stories Feature

**Firestore Structure:**
```
status/
  └── {userId}/
      ├── userModel: Map
      ├── userId: String
      ├── visibleTo: Array<String>
      └── statusEntities: Array<{
              statusEntityId: String
              statusEntityType: String
              statusMediaText: String (URL for media)
              timePosted: Timestamp
          }>
```

**Status Types:**
- Text status
- Image status
- Video status
- GIF status

**Key Features:**
- 24-hour auto-expiry (handled client-side)
- Privacy: visible only to contacts
- Multiple status updates per user
- Status viewer list
- Story-like interface using `story_view` package

**Controller Methods:**
- `uploadTextStatusEntity()`: Post text status
- `uploadPhotoVideoAudioStatusEntity()`: Post media status
- `uploadGIFStatusEntity()`: Post GIF status
- `getStatusModelList()`: Stream all visible status updates

### 5. Contact Selection

**Features:**
- Sync device contacts using `flutter_contacts`
- Filter contacts registered on the app
- Multi-select for group creation
- Single-select for direct chat

**Workflow:**
1. Request contacts permission
2. Fetch device contacts
3. Check which contacts are registered (exist in Firestore)
4. Display only registered contacts
5. Navigate to chat/create group based on selection

---

## 📊 Data Models

### UserModel
```dart
class UserModel {
  final String uid;
  final String name;
  final String phoneNumber;
  final String profilePic;          // Firebase Storage URL
  final bool isOnline;
  final List<String> groupsId;
}
```

### MessageModel
```dart
class MessageModel {
  final String text;                 // Message content or media URL
  final DateTime time;
  final String messageId;
  final bool isSeen;
  final UserModel senderUserModel;
  final UserModel receiverUserModel;
  final MessageType messageType;    // enum: text, image, video, audio, gif
  final MessageReplyModel messageReplyModel;
}
```

### GroupModel
```dart
class GroupModel {
  final String groupId;
  final String groupName;
  final String groupProfilePicUrl;
  final List<String> groupMembersIds;
  final String lastMessageUserId;
  final String lastMessageUserName;
  final String lastMessageText;
  final DateTime lastMessageTime;
}
```

### StatusModel
```dart
class StatusModel {
  final UserModel userModel;
  final String statusId;
  final List<String> visibleTo;     // User IDs who can see this status
  final List<StatusEntity> statusEntities;
}

class StatusEntity {
  final MessageType statusEntityType;
  final String statusMediaText;     // URL or text content
  final DateTime timePosted;
  final String statusEntityId;
}
```

### MessageReplyModel
```dart
class MessageReplyModel {
  final String userName;
  final bool isMe;
  final MessageType type;
  final String text;
}
```

### ContactChat
```dart
class ContactChat {
  final String name;
  final String profilePic;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String contactId;
  final bool isGroupChat;
}
```

---

## 🔄 State Management

The app uses **Riverpod** for state management with a provider-based architecture:

### Provider Types Used:

1. **Provider**: For immutable dependencies
   ```dart
   final authControllerProvider = Provider((ref) => AuthController(...));
   ```

2. **FutureProvider**: For async data fetching
   ```dart
   final getCurrentUserProvider = FutureProvider((ref) {
     return authController.getCurrentUser();
   });
   ```

3. **StreamProvider**: For real-time data streams
   ```dart
   final chatStreamProvider = StreamProvider.family<List<Message>, String>((ref, userId) {
     return chatController.getChatMessages(userId);
   });
   ```

4. **StateProvider**: For simple state
   ```dart
   final isLoadingProvider = StateProvider<bool>((ref) => false);
   ```

### Architecture Pattern:

```
UI (ConsumerWidget)
  ↓
Controller (Business Logic)
  ↓
Repository (Data Access)
  ↓
Firebase (Backend)
```

### Key Providers in the App:

| Provider | Type | Purpose |
|----------|------|---------|
| `authControllerProvider` | Provider | Authentication management |
| `chatControllerProvider` | Provider | Chat operations |
| `groupControllerProvider` | Provider | Group management |
| `statusControllerProvider` | Provider | Status operations |
| `getCurrentUserProvider` | FutureProvider | Fetch current user data |
| `isLoggedInProvider` | StateProvider | Track login state |
| `isLoadingProvider` | StateProvider | Global loading state |

---

## 🎨 UI/UX Design

### Theme

The app uses a **dark theme** inspired by WhatsApp's official design with colors defined in [colors.dart](lib/colors.dart):

**Color Palette:**
- `backgroundColor`: Dark background (19, 28, 33)
- `textColor`: White text (241, 241, 242)
- `appBarColor`: Dark app bar (31, 44, 52)
- `messageColor`: Teal for sender (5, 96, 98)
- `senderMessageColor`: Grey for receiver (37, 45, 49)
- `tabColor`: WhatsApp green (0, 167, 131)

### Responsive Design

The app provides optimized layouts for mobile and web platforms with responsive widgets.

---

## 🔐 Security & Permissions

### Required Permissions

**Android**: Internet, Contacts, Camera, Storage, Microphone

**iOS**: Camera, Photo Library, Microphone, Contacts usage descriptions in Info.plist

The app uses `permission_handler` package to manage runtime permissions.

---

## 🚀 Building & Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release  # For Play Store
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

---

## 🎥 Demo

Watch the full working demo:

[![WhatsApp Clone Demo](https://img.youtube.com/vi/2JMWxHKIKUs/maxresdefault.jpg)](https://www.youtube.com/watch?v=2JMWxHKIKUs)

---

## 🤝 Contributing

Contributions are welcome! Steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please follow Flutter style guidelines and add tests for new features.

---

## 📄 License

This project is available under the MIT License.

---

## 👨‍💻 Author

**Amanat Singh**

- GitHub: [@amanat-2003](https://github.com/amanat-2003)
- Project: [WhatsApp Clone](https://github.com/amanat-2003/whatsapp_clone)

---

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **Firebase Team**: For robust backend services
- **Riverpod Community**: For excellent state management solution
- **Open Source Community**: For valuable packages and libraries
- **WhatsApp**: For design inspiration

---

## 🔮 Future Enhancements

Planned features for future releases:

- [ ] **Voice/Video Calls**: WebRTC integration
- [ ] **End-to-End Encryption**: Secure message encryption
- [ ] **Message Forwarding**: Forward to multiple chats
- [ ] **Chat Backup & Restore**: Cloud backup functionality
- [ ] **Multi-device Support**: Sync across devices
- [ ] **Message Search**: Search within conversations
- [ ] **Theme Toggle**: Dark/Light mode switching
- [ ] **Localization**: Multi-language support
- [ ] **Archive Chats**: Hide chats from main list
- [ ] **Starred Messages**: Save important messages
- [ ] **Message Deletion**: Delete for everyone feature
- [ ] **Admin Controls**: Enhanced group admin features
- [ ] **Broadcast Lists**: Send to multiple contacts
- [ ] **Chat Export**: Export chat history
- [ ] **Custom Notifications**: Per-chat notification settings

---

<div align="center">

### Made with ❤️ using Flutter

**If you found this project helpful, please give it a ⭐!**

[⬆ Back to Top](#whatsapp-clone---flutter-application)

</div>
