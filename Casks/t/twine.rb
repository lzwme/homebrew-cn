cask "twine" do
  version "2.9.2"
  sha256 "a583b55291f6c1a16a04198bdfb925d48eaf0beff58018e9b0d98aeaea47e6da"

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