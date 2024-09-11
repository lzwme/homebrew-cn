cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.13"
  sha256 arm:   "fffc088106368df42520d54a2420280541be27f2710f4952371ef959a26fea78",
         intel: "472aef75a65c8d9b3f0a51c02dcdf13a32e7dfce3c851f95a193daa2c653aee4"

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