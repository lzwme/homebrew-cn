cask "telegram-desktop@beta" do
  version "5.14.0"
  sha256 "fe0d55dd4963743781a36750311e5f636bb4a9dada84ff6fb0115474bd0d9b2b"

  url "https:github.comtelegramdesktoptdesktopreleasesdownloadv#{version}tsetup.#{version}.dmg",
      verified: "github.comtelegramdesktoptdesktop"
  name "Telegram Desktop"
  desc "Desktop client for Telegram messenger"
  homepage "https:desktop.telegram.org"

  auto_updates true
  conflicts_with cask: "telegram-desktop"
  depends_on macos: ">= :high_sierra"

  # Renamed to avoid conflict with telegram
  app "Telegram.app", target: "Telegram Desktop.app"

  zap trash: [
    "~LibraryApplication SupportTelegram Desktop",
    "~LibraryPreferencescom.tdesktop.Telegram.plist",
    "~LibrarySaved Application Statecom.tdesktop.Telegram.savedState",
  ]
end