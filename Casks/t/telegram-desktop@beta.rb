cask "telegram-desktop@beta" do
  version "5.14.3"
  sha256 "c9081aed4427587ddf9f933e1c1194e46aa9e771d5fe7a5270a91d18d6ea3801"

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