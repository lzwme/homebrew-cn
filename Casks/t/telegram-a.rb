cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.25"
  sha256 arm:   "487593fbc24449686e975ab38f60071f738fef6163f887ffd433c2b21320abc3",
         intel: "5924714d2a9da3b71344c845fe1e06682bd484c828fca0be9c6a6eea28bacea5"

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