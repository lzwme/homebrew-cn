cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.49"
  sha256 arm:   "f3d5778e877f54a616c8097800028e3f39ff2da5fc9613d491894bab5ddcbb75",
         intel: "074395608bcd7cf6d81ac18b2ab6c7e1c6a74aeb2ef813d4f1932f7519facd74"

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