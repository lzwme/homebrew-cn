cask "opencore-patcher" do
  version "0.6.7"
  sha256 "2b69b86ea8698491d279b4cd5e12f77b8b41166db3f8d522bb8449e03c818247"

  url "https://ghproxy.com/https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher-GUI.app.zip",
      verified: "github.com/dortania/OpenCore-Legacy-Patcher/"
  name "OpenCore Legacy Patcher GUI"
  desc "Boot loader to inject/patch current features for unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  app "OpenCore-Patcher.app"

  uninstall delete: "/Library/LaunchAgents/com.dortania.opencore-legacy-patcher.auto-patch.plist"

  zap trash: [
    "~/Library/Application Support/CrashReporter/OpenCore-Patcher*",
    "~/Library/Preferences/com.dortania.opencore-legacy-patcher-wxpython.plist",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher-wxpython.savedState",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher.savedState",
    "/Users/Shared/.com.dortania.opencore-legacy-patcher.plist",
  ]
end