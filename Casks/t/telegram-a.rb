cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.4.2"
  sha256 arm:   "4d9582d970174c00c760b64e7aa33438add3276220aac42fbe23cbb77a77337b",
         intel: "3c3446d993abbdbb1b467a8e898162712e74346f80227386b65d7be3ca047c2f"

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