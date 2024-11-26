cask "twine" do
  version "2.10.0"
  sha256 "91ab5271f094639727eab057ef41347866ecec1d3cf71bcfe7608bf4886bb2e6"

  url "https:github.comklembottwinejsreleasesdownload#{version}Twine-#{version}-macOS.dmg",
      verified: "github.comklembottwinejs"
  name "Twine"
  desc "Tool for telling interactive, nonlinear stories"
  homepage "https:twinery.org"

  depends_on macos: ">= :high_sierra"

  app "Twine.app"

  zap trash: [
    "~LibraryApplication SupportTwine",
    "~LibraryLogsTwine",
    "~LibraryPreferencescom.electron.twine.plist",
    "~LibrarySaved Application Statecom.electron.twine.savedState",
  ]
end