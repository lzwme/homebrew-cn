cask "clementine" do
  version "1.3.1"
  sha256 "825aa66996237e1d3ea2723b24188ead203f298d0bec89f4c3bc6582d9e63e3a"

  url "https:github.comclementine-playerClementinereleasesdownload#{version}clementine-#{version}.dmg",
      verified: "github.comclementine-playerClementine"
  name "Clementine"
  desc "Music player and library organiser"
  homepage "https:www.clementine-player.org"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-30", because: :discontinued

  app "clementine.app"

  zap trash: [
    "~LibraryApplication SupportClementine",
    "~LibraryCachesorg.clementine-player.Clementine",
    "~LibraryPreferencesorg.clementine-player.Clementine.plist",
    "~LibrarySaved Application Stateorg.clementine-player.Clementine.savedState",
  ]

  caveats do
    requires_rosetta
  end
end