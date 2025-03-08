cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.43"
  sha256 arm:   "cab9c6487312fb74a8326e0800cb208998ffcd43c0d8cda05c7e1ac311aa72b4",
         intel: "f48d1cbf85d9c3dd715ba063f9771c2244362d63ce5b7c75e725e1719a717bd1"

  url "https:github.comAjaxytelegram-ttreleasesdownloadv#{version}Telegram-A-#{arch}.dmg",
      verified: "github.comAjaxytelegram-tt"
  name "Telegram A"
  desc "Web client for Telegram messenger"
  homepage "https:web.telegram.orgaget"

  depends_on macos: ">= :high_sierra"

  app "Telegram A.app"

  zap trash: [
    "~LibraryApplication SupportTelegram A",
    "~LibraryPreferencesorg.telegram.TelegramA.plist",
    "~LibrarySaved Application Stateorg.telegram.TelegramA.savedState",
  ]
end