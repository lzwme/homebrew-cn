cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.4.3"
  sha256 arm:   "264d74a498ddd9a033a531c33bffebd889fa8a6851d8653a47b0c467c8d7d24a",
         intel: "ab968fda075cb9396aa2c7e6c087d7e0ffebfddc973cc0d54058ad8ce8408c26"

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