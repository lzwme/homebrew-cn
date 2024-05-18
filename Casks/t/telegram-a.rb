cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.7"
  sha256 arm:   "64904a85318b864a418dc63399fd9e6d9642ed2a0ece67976be825f82340ac13",
         intel: "10026789110163273e63475f561995a821395624a47aa9ee2d2e278beba5d47f"

  url "https:github.comAjaxytelegram-ttreleasesdownloadv#{version}Telegram-A-#{arch}.dmg",
      verified: "github.comAjaxytelegram-tt"
  name "Telegram A"
  desc "Web client for Telegram messenger"
  homepage "https:web.telegram.orgaget"

  depends_on macos: ">= :sierra"

  app "Telegram A.app"

  zap trash: [
    "~LibraryApplication SupportTelegram A",
    "~LibraryPreferencesorg.telegram.TelegramA.plist",
    "~LibrarySaved Application Stateorg.telegram.TelegramA.savedState",
  ]
end