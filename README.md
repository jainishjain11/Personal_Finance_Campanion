# 💸 Personal Finance Companion

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/Material%203-blue?style=for-the-badge)

Welcome to the **Personal Finance Companion**. This project was built to evaluate mobile product thinking, architecture design, and UI/UX implementation. 

Rather than building a standard CRUD application, I approached this as a **frictionless, premium-feeling financial utility**. The core philosophy behind this app is **Speed, Privacy, and Polish**. It utilizes a 100% offline-first architecture, sub-millisecond local data querying, and native-feeling interactions.

---

## 🛑 Evaluator's Fast-Track Guide

I value your time. To evaluate the app's visualizations and logic without manually inputting dozens of transactions, please follow these steps:

1. Launch the application in your emulator or device.
2. Tap the **Settings (Gear Icon)** in the top right corner of the Home Dashboard.
3. Tap **"Load Demo Data"**.

**What happens?** The app will safely clear the database and inject a curated, 30-day realistic snapshot of a Computer Science student's finances (e.g., Vercel Subscriptions, Hackathon transport, Canteen lunches). 
* You can now instantly explore the **Insights** charts, see the **No-Spend Streak** calculation, and interact with the **Financial Health Score** and **FinBot**.

---

## ✨ Standout Features (Different from standard apps)

To demonstrate a senior-level approach to mobile development, I implemented several advanced features:

### 🤖 1. FinBot: On-Device NLP Assistant
I bypassed standard search bars and cloud-based LLMs to build **FinBot**—a 100% local Natural Language Processing assistant. 
* **Interaction:** Tap the `✨` FAB on the dashboard to chat.
* **Capabilities:** Type *"Spent ₹400 on lunch"* to instantly log an expense, or *"What is my balance?"* to query the database.
* **The Flex:** This utilizes advanced RegEx parsing against the local Hive NoSQL database. It requires **zero API keys, zero network latency, and ensures absolute user privacy.**

### 🎛️ 2. Gamified Financial Health Score
Instead of relying entirely on heavy third-party packages for UI, I built a custom **Financial Health Gauge** using Flutter's native `CustomPainter`. 
* It calculates a real-time 0–100 score by analyzing active No-Spend streaks, Income-to-Expense ratios, and category allowance limits, dynamically interpolating colors (Red/Yellow/Green) based on financial stamina.

### ⚡ 3. Frictionless Data Entry UX
Adding a transaction should take less than two seconds.
* **Custom Keypad:** I designed a custom, touch-friendly 10-key numeric pad to replace clunky OS keyboards.
* **Haptics:** Integrated `HapticFeedback.lightImpact` to give the app a premium, tactile "native" feel.
* **Smart Parsing:** Auto-formats currency inputs seamlessly.

### 🎨 4. Multiple Currency Toggle
The app supports multiple currency to select from and use it.

---

## 🏗️ Architecture & Tech Stack

This application follows a **Feature-First Architecture** to ensure high cohesion and low coupling, making it highly scalable.

* **Framework:** Flutter (Dart)
* **State Management:** **Riverpod** (`flutter_riverpod` + `riverpod_generator`). I utilized code generation to ensure immutable, type-safe, and highly predictable state injection, avoiding the boilerplate of standard `ChangeNotifier` patterns.
* **Local Data Persistence:** **Hive** (`hive` + `hive_flutter`). Chosen for its synchronous, zero-latency NoSQL key-value store. This ensures the app operates seamlessly offline.
* **Routing:** **GoRouter** (`go_router`) for declarative, deep-linkable, and scalable bottom-navigation shell routing.
* **Visualizations:** `fl_chart` for highly interactive Pie and Bar charts.

### Folder Structure (Abridged)
```text
lib/
├── core/
│   ├── router/            # GoRouter configuration & shell routing
│   ├── theme/             # Material 3 Dynamic Colors & Typography
│   └── utils/             # Formatters (currency, dates)
├── features/
│   ├── chat/              # FinBot NLP Logic & Chat UI
│   ├── home/              # Dashboard, Health Gauge CustomPainter
│   ├── insights/          # fl_chart implementations & Smart Projections
│   ├── settings/          # Currency toggles, Theme toggles, Mock Data Seeder
│   └── transactions/      # Hive Models, Riverpod Providers, Custom Keypad UI
└── main.dart
```
# 🤔 Assumptions & Trade-Offs

## Hive over SQLite/Isar
I opted for Hive because it is a pure Dart key-value store. For a personal finance app where the primary operations are simple CRUD lists and rapid aggregations, Hive provides superior read speeds without the native dependency compilation overhead of SQLite.

## Offline NLP over Cloud LLMs
While integrating the OpenAI API would allow for more conversational flexibility, it introduces network latency, privacy concerns, and requires the evaluator to supply API keys. Building a local RegEx parser demonstrates an understanding of mobile constraints and offline-first product design.

## Biometrics Omitted
Local authentication was considered but intentionally omitted to ensure a frictionless evaluation experience across all emulator configurations.

---

# 💻 Installation & Setup

Ensure you have the Flutter SDK installed and configured on your machine.

```bash
# 1. Clone the repository and navigate into it
cd personal_finance_companion

# 2. Fetch all dependencies
flutter pub get

# 3. Run the build_runner (CRITICAL: Generates Riverpod states and Hive adapters)
dart run build_runner build -d

# 4. Build and run the application
flutter run
```

---

Thankyou!

Jainish Jain
