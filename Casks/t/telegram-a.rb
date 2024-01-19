cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.4.4"
  sha256 arm:   "c7ae0fae7071bdb47bc093a4a3e5ec24c36f5a6672d357fdd8ab4cb04c5e8116",
         intel: "1e9ff57fe1f20d4320bcfc7c03b8a79ea5c5d833b751e71c4ca24f22612a82ce"

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