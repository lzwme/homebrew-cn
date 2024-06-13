cask "pyfa" do
  version "2.59.1"
  sha256 "9f3f4cc562858e10bffb0ec60d4b67dac3208fab52830830fb7c5c1860cd3ea5"

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