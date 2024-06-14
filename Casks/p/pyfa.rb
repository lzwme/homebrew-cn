cask "pyfa" do
  version "2.59.2"
  sha256 "e3a366c4411c78279f49b11f090c17ef2ccba053524a72ad5da15594a6090aab"

  url "https:github.compyfa-orgPyfareleasesdownloadv#{version}pyfa-v#{version}-mac.zip"
  name "pyfa"
  desc "Fitting tool for EVE Online"
  homepage "https:github.compyfa-orgPyfa"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "pyfa.app"

  zap trash: [
    "~LibraryCachesorg.pyfaorg.pyfa",
    "~LibraryPreferencesorg.pyfaorg.pyfa.plist",
    "~LibrarySaved Application Stateorg.pyfaorg.pyfa.savedState",
  ]
end