cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.10"
  sha256 arm:   "1f90c5e255c4c37c9af26a5c32b0367cb9ff42dfe12d7de0374e2db14730b3dc",
         intel: "42cf57f9e5ea10a51c66758fb2e17edaf314475215f403f71fbae865d0235b9a"

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