cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.4.1"
  sha256 arm:   "e235563eb97d1cd089418bd8c92d7c66544a105ddadfcc84da78a037f8f0c542",
         intel: "09aab42b762ae7be1ee1702457fbee711127c9c87c568f650c193ff94c57d480"

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