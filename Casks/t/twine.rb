cask "twine" do
  version "2.9.1"
  sha256 "23344fe5707f535ca56bed6dcf9fc56c3fc110576ac19d7e56d576124f94ce24"

  url "https:github.comklembottwinejsreleasesdownload#{version}Twine-#{version}-macos.dmg",
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