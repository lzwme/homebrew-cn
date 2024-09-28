cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.16"
  sha256 arm:   "1c1f0479e97f87745bf52cc5c67b6d1ed517ec269023475b2033d620d50c8a69",
         intel: "0581c1c87ddbcbe77f681f74aef9463d2786e0d7faf2a92a9efac9e78a7280cf"

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