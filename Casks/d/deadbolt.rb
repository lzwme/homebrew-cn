cask "deadbolt" do
  version "1.0.0"
  sha256 "df5b9b0988f168946809f1db17711f589f62bc211a6dad724eac9b0844285370"

  url "https:github.comalichtmandeadboltreleasesdownload#{version}Deadbolt-#{version}-mac.zip"
  name "Deadbolt"
  desc "File encryption tool"
  homepage "https:github.comalichtmandeadbolt"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Deadbolt.app"

  zap trash: [
    "~LibraryApplication Supportdeadbolt",
    "~LibraryPreferencesorg.alichtman.deadbolt.plist",
    "~LibrarySaved Application Stateorg.alichtman.deadbolt.savedState",
  ]

  caveats do
    requires_rosetta
  end
end