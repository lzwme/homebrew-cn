cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.18"
  sha256 arm:   "b14b599dd05b407edb50a36487b39f50572c3bed30f79721c14d707bd705a1ab",
         intel: "56dde3c2e1aed75740c34477f5798bfc91be61fd4bd98a6927cc5072b9fb2232"

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