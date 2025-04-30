# Creative Piece Dissertation

Calorie Tracking Application - Following Data Science Themes for dissertation project

## Getting Started

This guide will walk you through the steps to set up Flutter, install Android Studio, and configure a virtual device for testing the Flutter application.

---

## Step 1: Install Flutter

1. **Download Flutter SDK**:
   - Visit the [Flutter website](https://docs.flutter.dev/get-started/install) and download the Flutter SDK for your operating system.

2. **Extract the Flutter SDK**:
   - Extract the downloaded file to a location of your choice (e.g., `C:\flutter` on Windows or `/Users/<your-username>/flutter` on macOS).

3. **Add Flutter to PATH**:
   - Add the Flutter `bin` directory to your system's PATH environment variable:
     - **Windows**:
       - Open "Edit the system environment variables."
       - Add `C:\flutter\bin` to the PATH variable.
     - **macOS/Linux**:
       - Open your terminal and edit the shell configuration file (`~/.zshrc`, `~/.bashrc`, or `~/.bash_profile`).
       - Add the line: `export PATH="$PATH:/path-to-flutter/bin"`

4. **Verify Installation**:
   - Run the following command in your terminal or command prompt:
     ```sh
     flutter doctor
     ```
   - Follow any instructions to resolve missing dependencies.

---

### Common Issues and Fixes for `flutter doctor` (Visual Studio Code)

1. **Flutter Plugin Not Installed in VS Code**:
   - **Error**: `✗ Flutter plugin not installed; this adds Flutter-specific functionality.`
   - **Fix**:
     - Open Visual Studio Code.
     - Go to **Extensions** (Ctrl+Shift+X or Cmd+Shift+X on macOS).
     - Search for "Flutter" and install the Flutter extension.
     - The Dart extension will be installed automatically as a dependency.

2. **Dart SDK Not Found**:
   - **Error**: `✗ Dart SDK not found.`
   - **Fix**:
     - Ensure the Flutter SDK is correctly installed and added to your PATH.
     - Run the following command to verify:
       ```sh
       flutter doctor
       ```
     - If the issue persists, reinstall the Flutter SDK and ensure the `bin` directory is in your PATH.

3. **Android SDK Not Found**:
   - **Error**: `✗ Unable to locate Android SDK.`
   - **Fix**:
     - Install Android Studio (see Step 2 in the guide above).
     - Open Android Studio and go to **File > Settings > Appearance & Behavior > System Settings > Android SDK**.
     - Install the latest Android SDK and ensure the `Android SDK Platform-Tools` are installed.
     - Add the Android SDK path to your environment variables:
       - **Windows**:
         - Add the path to `ANDROID_HOME` (e.g., `C:\Users\<your-username>\AppData\Local\Android\Sdk`).
       - **macOS/Linux**:
         - Add the following to your shell configuration file:
           ```sh
           export ANDROID_HOME=$HOME/Library/Android/sdk
           export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
           ```

4. **Missing `adb` Command**:
   - **Error**: `✗ adb not found. Ensure that Android SDK is installed and its directory is in your PATH.`
   - **Fix**:
     - Ensure the Android SDK Platform-Tools are installed in Android Studio.
     - Add the `platform-tools` directory to your PATH:
       - **Windows**:
         - Add `C:\Users\<your-username>\AppData\Local\Android\Sdk\platform-tools` to your PATH.
       - **macOS/Linux**:
         - Add the following to your shell configuration file:
           ```sh
           export PATH=$PATH:$ANDROID_HOME/platform-tools
           ```

5. **No Connected Devices Found**:
   - **Error**: `✗ No devices available.`
   - **Fix**:
     - Ensure you have a virtual device set up in Android Studio (see Step 3 in the guide above).
     - Start the emulator from Android Studio or run the following command:
       ```sh
       flutter emulators --launch <emulator-id>
       ```
     - Replace `<emulator-id>` with the ID of your emulator (you can list available emulators with `flutter emulators`).

6. **Flutter PATH Not Set**:
   - **Error**: `✗ Flutter SDK not found.`
   - **Fix**:
     - Ensure the Flutter SDK is added to your PATH environment variable:
       - **Windows**:
         - Add `C:\flutter\bin` to your PATH.
       - **macOS/Linux**:
         - Add the following to your shell configuration file:
           ```sh
           export PATH="$PATH:/path-to-flutter/bin"
           ```
     - Restart your terminal or IDE after updating the PATH.

7. **CocoaPods Not Installed (macOS Only)**:
   - **Error**: `✗ CocoaPods not installed.`
   - **Fix**:
     - Install CocoaPods using Homebrew:
       ```sh
       brew install cocoapods
       ```
     - Run the following command to set up CocoaPods:
       ```sh
       pod setup
       ```

8. **VS Code Debugger Not Working**:
   - **Error**: Debugger does not attach or app does not run.
   - **Fix**:
     - Ensure the Flutter extension is installed in VS Code.
     - Open the command palette (Ctrl+Shift+P or Cmd+Shift+P on macOS) and select **Flutter: Select Device**.
     - Choose the connected emulator or physical device.
     - Run the app using the **Run and Debug** button or by pressing `F5`.

---

For more details, refer to the [Flutter documentation](https://docs.flutter.dev/).

## Step 2: Install Android Studio

1. **Download Android Studio**:
   - Visit the [Android Studio website](https://developer.android.com/studio) and download the installer for your operating system.

2. **Install Android Studio**:
   - Follow the installation instructions for your operating system.

3. **Install Required Components**:
   - Open Android Studio and go to **File > Settings > Appearance & Behavior > System Settings > Android SDK**.
   - Install the following:
     - **SDK Platforms**: Select the latest Android version.
     - **SDK Tools**: Ensure the following are checked:
       - Android SDK Build-Tools
       - Android Emulator
       - Android Platform-Tools
       - Intel x86 Emulator Accelerator (HAXM)

---

## Step 3: Install Packages

After you have installed android studio and flutter doctor is returning the required options green (Anything to do with chrome or visual studio can be ignoredd). You can now install the dependencies, Flutter uses the `pub` package manager to manage dependencies. Follow these steps to install the required packages for this project:

1. **Add Packages**:
   - Use the `flutter pub add` command to add the following packages to your project:
     ```sh
     flutter pub add provider
     flutter pub add material
     flutter pub add intl
     flutter pub add fl_chart
     flutter pub add flutter_zxing
     flutter pub add path
     flutter pub add sqflite
     flutter pub add http
     flutter pub add shared_preferences
     flutter pub add json_annotation
     ```

2. **Install All Dependencies**:
   - Run the following command to install all dependencies listed in your `pubspec.yaml` file:
     ```sh
     flutter pub get
     ```

3. **Verify Installation**:
   - Ensure the packages are installed by checking the `pubspec.lock` file or by running:
     ```sh
     flutter pub outdated
     ```
   - This command will show if any dependencies are outdated.

4. **Update Dependencies**:
   - To update all dependencies to their latest versions, run:
     ```sh
     flutter pub upgrade
     ```

---

### Explanation of Packages:
- **`provider`**: State management solution for Flutter.
- **`material`**: Provides Material Design components for Flutter apps.
- **`intl`**: Internationalization and localization support, including date and number formatting.
- **`fl_chart`**: A library for creating beautiful charts in Flutter.
- **`flutter_zxing`**: A library for barcode and QR code scanning.
- **`path`**: Provides utilities for manipulating file paths.
- **`sqflite`**: A plugin for SQLite database management.
- **`http`**: A package for making HTTP requests.
- **`shared_preferences`**: A plugin for storing simple key-value pairs locally.
- **`json_annotation`**: Provides annotations for JSON serialization and deserialization.

---

## Step 4: Set Up a Virtual Device in Android Studio

1. **Open Virtual Device Manager**:
   - In Android Studio, go to **Tools > Device Manager**.

2. **Create a New Virtual Device**:
   - Click on **Create Device**.
   - Select a hardware profile (e.g., Pixel 5) and click **Next**.

3. **Select a System Image**:
   - Choose a system image (e.g., Android 12.0) and click **Next**.
   - Download the image if it is not already available.

4. **Configure the Emulator**:
   - Set up the emulator settings (e.g., orientation, RAM, etc.) and click **Finish**.

5. **Start the Emulator**:
   - Click the **Play** button next to your virtual device to start it.

---

## Step 5: Connect Flutter to the Emulator

1. **Verify Emulator Connection**:
   - Start the emulator and run the following command in your terminal:
     ```sh
     flutter devices
     ```
   - You should see your emulator listed as a connected device. If you have a device open, it will automatically detect the device as initial open.

2. **Run Your Flutter App**:
   - Navigate to your Flutter project directory and run:
     ```sh
     flutter run
     ```
   - Your app will launch on the emulator.

---

## Step 6: Useful Flutter Commands

When your Flutter application is running, you can use the following commands in the terminal to interact with the app:

1. **Hot Reload**:
   - Use this command to quickly reload changes in your code without restarting the app:
     ```sh
     r
     ```
   - This is useful for UI changes and minor updates.

2. **Hot Restart**:
   - Use this command to restart the app while preserving the state:
     ```sh
     R
     ```
   - This is useful for testing stateful widgets.

3. **Quit the Application**:
   - Use this command to stop the running application:
     ```sh
     q
     ```

4. **Show Widget Tree**:
   - Use this command to display the widget tree in the terminal:
     ```sh
     w
     ```

5. **Toggle Debug Paint**:
   - Use this command to visualize widget boundaries and layouts:
     ```sh
     p
     ```

6. **Toggle Performance Overlay**:
   - Use this command to display the performance overlay:
     ```sh
     o
     ```

7. **Toggle Debug Banner**:
   - Use this command to hide or show the "Debug" banner in the app:
     ```sh
     b
     ```

8. **Dump Accessibility Tree**:
   - Use this command to display the accessibility tree:
     ```sh
     a
     ```

9. **Clear the Terminal**:
   - Use this command to clear the terminal output:
     ```sh
     c
     ```

10. **Restart the Application**:
    - If the app crashes or you want to restart it completely, stop the app with `q` and run:
      ```sh
      flutter run
      ```

---


## Additional Information
  **Add a photo to device camera**
   - When the emulated device is open go to **3 dots on right side of device > Camera > Select file**
       - This will display an image inside of the emulator when searching barcode scan
       - Hold down the **ALT** key and use **WASD** to move and **MOUSE** to view inside the emulator. **E & Q** raise the view vertically up and down

   **API Additional Information**
    - The API is capped to a certain number of requests per day per IP, with how certain pages function ensure that these pages are not left on standby for too long.
    - Example pages are any page with search feature or barcode scan page, since the page has to detect if a user value has been entered.
    - If requests fail due to, to many requests sent the solution is using a VPN.
        - ProtonVPN is a good VPN, as enabling the VPN will generate a masked IP, unblocking you [ProtonVPN Install](https://protonvpn.com/?srsltid=AfmBOopccbz5OBN-c2zeuEjJCp15jO0Fan8hGadk3PZUxmzo3tp-6ayj)
        - Follow the installation steps on page, however this is a last restor

  **Devices to select**
   - Testing was completed on a pixel 8 Pro, so for testing the same device should be used again
   - Althought the pages are designed to fit on multiple devices, some buttons may not scale to size correctly e.g: Tablets or Ipads
   - Testing must be completed on an android device, since macbook is required to test IOS due to needing an apple dev account. All builds were build on android.
For more details, refer to the [Flutter documentation](https://docs.flutter.dev/).