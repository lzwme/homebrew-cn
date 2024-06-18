cask "twine" do
  version "2.9.0"
  sha256 "e266539bff4cb605800bbe40ec025dabee324953c370c8743e7b90e1cc973813"

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