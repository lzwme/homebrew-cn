cask "beekeeper-studio" do
  arch arm: "-arm64"

  version "4.4.0"
  sha256 arm:   "6fa98064114e7666ef52a6ec9c9ac031dfd61e0ebe88f3442b5a0f4f884344f3",
         intel: "50829e925a34e7b4a5c9d46047edbd0812a4c60ad25cd670177d275bc05a1aed"

  url "https:github.combeekeeper-studiobeekeeper-studioreleasesdownloadv#{version}Beekeeper-Studio-#{version}#{arch}.dmg",
      verified: "github.combeekeeper-studiobeekeeper-studio"
  name "Beekeeper Studio"
  desc "Cross platform SQL editor and database management app"
  homepage "https:www.beekeeperstudio.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Beekeeper Studio.app"

  zap trash: [
    "~LibraryApplication Supportbeekeeper-studio",
    "~LibraryApplication SupportCachesbeekeeper-studio-updater",
    "~LibraryCachesio.beekeeperstudio.desktop",
    "~LibraryCachesio.beekeeperstudio.desktop.ShipIt",
    "~LibraryPreferencesByHostio.beekeeperstudio.desktop.ShipIt.*.plist",
    "~LibraryPreferencesio.beekeeperstudio.desktop.plist",
    "~LibrarySaved Application Stateio.beekeeperstudio.desktop.savedState",
  ]
end