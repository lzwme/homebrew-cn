cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.45"
  sha256 arm:   "c504e8bf69fff63ea10b72691cbc8be12cc3bab7a39b1696e87d5601a734a3dd",
         intel: "9ee9ea447af7f5c93fbb0fbf1c5285ed55c4637945360af0ce98add926bcd00c"

  url "https:github.comAjaxytelegram-ttreleasesdownloadv#{version}Telegram-A-#{arch}.dmg",
      verified: "github.comAjaxytelegram-tt"
  name "Telegram A"
  desc "Web client for Telegram messenger"
  homepage "https:web.telegram.orgaget"

  depends_on macos: ">= :high_sierra"

  app "Telegram A.app"

  zap trash: [
    "~LibraryApplication SupportTelegram A",
    "~LibraryPreferencesorg.telegram.TelegramA.plist",
    "~LibrarySaved Application Stateorg.telegram.TelegramA.savedState",
  ]
end