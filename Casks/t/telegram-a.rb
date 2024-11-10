cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.21"
  sha256 arm:   "fbeda46679769a08e2f6855411b1cca8685d961d691295cc07f349986259d9bf",
         intel: "7cea96f897e699c39bb73cb97bbd89a7951dcd05015d4b60d768b76165a030fb"

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