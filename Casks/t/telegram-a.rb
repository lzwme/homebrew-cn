cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.8"
  sha256 arm:   "0c73538aac5b3d271978e1d7d87e7667d287210ae29587d70d02c4933803b814",
         intel: "39a691cb8ecc829d2e4b21002a990be7d1c4fb794a6025e83abe7dfa3b09da4b"

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