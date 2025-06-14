cask "telegram-desktop@beta" do
  version "5.15.4"
  sha256 "2da56b5e5a3a50e8dc82312f9fe94530eb114ffaa3cc2add608edf5ce575f5d2"

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