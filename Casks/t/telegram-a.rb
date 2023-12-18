cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.0.25"
  sha256 arm:   "38d5f9f9d14a36127b96e5b7f27c7894dffa9ed1d7ee22aaa66306c004b7d10f",
         intel: "34436dceaf5b95aaa274b765f8c25d567c96f0e98d9088e89064abfa485db43e"

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