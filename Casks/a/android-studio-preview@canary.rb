cask "android-studio-preview@canary" do
  arch arm: "mac_arm", intel: "mac"

  version "2025.1.4.3"
  sha256 arm:   "7577cc713ca4af995990a24be0bebda2ff2e6247fd77f99933f70d5bf1b3a17b",
         intel: "c7a88aafa8e4c6d64f3529221df21f4e7cda14baf5603a7098d71f4a57c3f6e9"

  url "https://redirector.gvt1.com/edgedl/android/studio/install/#{version}/android-studio-#{version}-#{arch}.dmg",
      verified: "redirector.gvt1.com/edgedl/android/studio/install/"
  name "Android Studio Preview (Canary)"
  desc "Tools for building Android applications"
  homepage "https://developer.android.com/studio/preview/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/android[._-]studio[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmg}i)
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Android Studio Preview.app", target: "Android Studio Preview Canary.app"
  binary "#{appdir}/Android Studio Preview Canary.app/Contents/MacOS/studio", target: "studio-canary"

  zap trash: [
        "~/.android",
        "~/Library/Android/sdk",
        "~/Library/Application Support/Google/AndroidStudioPreview#{version.major_minor}",
        "~/Library/Caches/Google/AndroidStudioPreview#{version.major_minor}",
        "~/Library/Logs/Google/AndroidStudioPreview#{version.major_minor}",
        "~/Library/Preferences/com.android.Emulator.plist",
        "~/Library/Preferences/com.google.android.studio-EAP.plist",
        "~/Library/Saved Application State/com.google.android.studio-EAP.savedState",
      ],
      rmdir: [
        "~/AndroidStudioProjects",
        "~/Library/Android",
      ]
end