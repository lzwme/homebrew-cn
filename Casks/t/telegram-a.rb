cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.42"
  sha256 arm:   "eca412b1c6e79e3c172304c1e195399ba3b59dbf6643fad7dd6ecfd229e0ce9e",
         intel: "c9f38378d10dfc3a89a261522bddb1a869cceb01e38332c3f59a92cf990d8cf8"

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