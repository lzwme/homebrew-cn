cask "telegram-desktop@beta" do
  version "5.15.2"
  sha256 "2b0c8eb8bb808a450822aa58d123d234a6ad7d6de9d289a9e1f605321a1888da"

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