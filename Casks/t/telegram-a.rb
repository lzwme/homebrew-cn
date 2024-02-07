cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.4.6"
  sha256 arm:   "2c4bd438907cbe8b196b7d71260fc6814ff61640d36e3ffe173fd75923443415",
         intel: "bb073aa6766b960c6991e53a0afb53fe52a0536a564b3cd8734eaab4abb499c9"

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