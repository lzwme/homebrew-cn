cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.23"
  sha256 arm:   "f85d1adeafa7ba4c9d31526c43b51045baa3fbde1a5ce1404a2f48648545b4f2",
         intel: "e1d96236c8f354f1b085a65dff289e3aee65ccfda661b2bf5e28f9ee98fb55a5"

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