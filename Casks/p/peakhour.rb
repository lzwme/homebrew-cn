cask "peakhour" do
  version "4.1.17"
  sha256 "aaf2d54a0345cf9ca58a6f67a56c986e69197ec37d763dd586983806089aa427"

  url "https://updates.peakhourapp.com/releases/PeakHour%20#{version}.zip"
  name "PeakHour"
  desc "Network bandwidth and network quality visualiser"
  homepage "https://old.peakhourapp.com/"

  deprecate! date: "2024-09-21", because: :moved_to_mas
  disable! date: "2025-09-24", because: :moved_to_mas

  auto_updates true

  app "PeakHour #{version.major}.app"

  uninstall launchctl: "com.digitician.peakhour#{version.major}.launchAtLoginHelper",
            quit:      "com.digitician.peakhour#{version.major}"

  zap trash: [
    "~/Library/Application Scripts/com.digitician.peakhour#{version.major}.launchAtLoginHelper",
    "~/Library/Application Support/com.digitician.peakhour#{version.major}",
    "~/Library/Application Support/PeakHour*",
    "~/Library/Caches/com.digitician.peakhour#{version.major}",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.digitician.peakhour#{version.major}",
    "~/Library/Containers/com.digitician.peakhour#{version.major}.launchAtLoginHelper",
    "~/Library/Cookies/com.digitician.peakhour#{version.major}.binarycookies",
    "~/Library/Preferences/com.digitician.peakhour#{version.major}.plist",
  ]
end