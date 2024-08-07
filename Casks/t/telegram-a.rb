cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.9"
  sha256 arm:   "16293fe32996d8ae6bc89aa345c9d4cc7d378820d24cb0e6231b3e38bbdf9374",
         intel: "dae0f6d96c30f8d23323da2315b69ac218d0729e7b8fb75755384a27f10e22c9"

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