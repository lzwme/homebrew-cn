cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.14"
  sha256 arm:   "cc9eeabae4e1891fa502bbc5f32fcd0a075d4bbeea47f03bbe9ec00bc26774af",
         intel: "6ebcfff15180ca7cb9069685c53ad22c96b9de53e446e5d973bfbe857af66781"

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