# Market Spy

A Flutter-based stock market tracking app with authentication and stock search functionality.

## Setup Instructions
1. **Clone the Repository:**
   ```sh
   git clone https://github.com/your-username/market-spy.git
   cd market-spy
   ```
2. **Install Dependencies:**
   ```sh
   flutter pub get
   ```
3. **Configure API Keys:**
   - Add your stock market API key in `lib/config/api_config.dart`.
   - Example:
     ```dart
     const String stockApiKey = "YOUR_API_KEY";
     ```
4. **Run the App:**
   ```sh
   flutter run
   ```

## Dependencies
- `flutter_riverpod` for state management
- `firebase_auth` for authentication
- `http` for API calls

