cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.5"
  sha256 arm:   "ee68f37af991735268d69df859f218f5b169b3b10d878b0cab9e357df5c04236",
         intel: "4e0dfc4edc86a48915efcd424e19172555ab77d628a66921c156289bf45420df"

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