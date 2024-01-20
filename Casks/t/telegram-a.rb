cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.4.5"
  sha256 arm:   "e20531236047ed4189e49d2c6c0ddc968126ab72dcfb7ea085d069733fbb728a",
         intel: "46b7727c536ac2a908d062f6403f10d925dbc9d27df408e42d5ffefda2c29a24"

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