cask "telegram-desktop" do
  version "4.9.9"
  sha256 "32e2c027676cef3cf6b8a75ae93f11f4b748ccb5a97a86f781f8be4a7d9d7452"

  url "https://updates.tdesktop.com/tmac/tsetup.#{version}.dmg",
      verified: "updates.tdesktop.com/tmac/"
  name "Telegram Desktop"
  desc "Desktop client for Telegram messenger"
  homepage "https://desktop.telegram.org/"

  livecheck do
    url "https://telegram.org/dl/desktop/mac"
    strategy :header_match
  end

  auto_updates true
  conflicts_with cask: "homebrew/cask-versions/telegram-desktop-beta"
  depends_on macos: ">= :sierra"

  # Renamed to avoid conflict with telegram
  app "Telegram.app", target: "Telegram Desktop.app"

  zap trash: [
    "~/Library/Application Support/Telegram Desktop",
    "~/Library/Preferences/com.tdesktop.Telegram.plist",
    "~/Library/Saved Application State/com.tdesktop.Telegram.savedState",
  ]
end