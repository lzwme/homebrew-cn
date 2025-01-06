cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.34"
  sha256 arm:   "973f38c0eb58821d5a60ef53468b4d7903518a237c322b2731ce066f4894d419",
         intel: "1b4356da699f4972b26730cb0b793847925e5782d85cb267e9639a067dc9079b"

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