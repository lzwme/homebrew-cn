cask "twine" do
  version "2.8.1"
  sha256 "c1f78f6d74e3ed121d586687b8f489cb4db0cca8b63847006e9b0d002064eff7"

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