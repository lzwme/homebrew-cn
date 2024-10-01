cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.17"
  sha256 arm:   "5f48172c7b68bbfd8829057c7ca513629c2b22cf2e7ac52bdde13855f7e61ca1",
         intel: "c6a80348451e3adc2dc760d277d707fc9669356d5fdf1e729b42e742d1d70829"

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