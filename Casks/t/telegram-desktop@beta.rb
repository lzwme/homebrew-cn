cask "telegram-desktop@beta" do
  version "5.13.1"
  sha256 "b026d5382b3ea55d5d8d03617a7107cc61b4e1e66580263a70cdab2b6863a370"

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