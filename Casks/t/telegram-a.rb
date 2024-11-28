cask "telegram-a" do
  arch arm: "arm64", intel: "x64"

  version "10.9.22"
  sha256 arm:   "453f576c6d49e9dad7f65bfdf5a03fdc168c0e3101e2351ff92d098a145816e9",
         intel: "635f65513f3e077a4c8c9c7864c3e3291a0c6bc6a19bb314ca5c33f8667bb70a"

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