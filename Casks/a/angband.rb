cask "angband" do
  version "4.2.5"
  sha256 "ea04557f8ad46d7e446fd4e76324774743bb6b073f6fe9b803256776707bbc66"

  url "https:github.comangbandangbandreleasesdownload#{version}Angband-#{version}-osx.dmg",
      verified: "github.comangbandangband"
  name "Angband"
  desc "Dungeon exploration game"
  homepage "https:angband.github.ioangband"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Angband.app"

  zap trash: [
    "~DocumentsAngband",
    "~LibraryPreferencesorg.rephial.angband.plist",
    "~LibrarySaved Application Stateorg.rephial.angband.savedState",
  ]
end