cask "beekeeper-studio" do
  arch arm: "-arm64"

  version "4.0.3"
  sha256 arm:   "0b236df18e6e8f36eebf659a2fc98f95428bb92dd043a1344fb852b5b636609a",
         intel: "98d63b7557bde466178e3ec448581058380eb91983c71cc4e7882a0151b6dbed"

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
    "~LibraryCachesio.beekeeperstudio.desktop.ShipIt",
    "~LibraryCachesio.beekeeperstudio.desktop",
    "~LibraryPreferencesByHostio.beekeeperstudio.desktop.ShipIt.*.plist",
    "~LibraryPreferencesio.beekeeperstudio.desktop.plist",
    "~LibrarySaved Application Stateio.beekeeperstudio.desktop.savedState",
  ]
end