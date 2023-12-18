cask "twine" do
  version "2.8.0"
  sha256 "dbe533f806607300c80414bd45494239797d658f3af288be361c58b5de9cd4f2"

  url "https:github.comklembottwinejsreleasesdownload#{version}Twine-#{version}-macos.dmg",
      verified: "github.comklembottwinejs"
  name "Twine"
  desc "Tool for telling interactive, nonlinear stories"
  homepage "https:twinery.org"

  app "Twine.app"

  zap trash: [
    "~LibraryApplication SupportTwine",
    "~LibraryLogsTwine",
    "~LibraryPreferencescom.electron.twine.plist",
    "~LibrarySaved Application Statecom.electron.twine.savedState",
  ]
end