cask "batteries" do
  version "2.3.2"
  sha256 "0b6331f3326eef32f661a680056c08a303c7e6b7172c4692b35730e5859dff7a"

  url "https:github.comronyfadelBatteriesReleasesreleasesdownloadv#{version}Batteries.dmg",
      verified: "github.comronyfadelBatteriesReleases"
  name "Batteries"
  desc "Track all your devices' batteries"
  homepage "https:www.fadel.iobatteries"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Batteries.app"

  zap trash: [
    "~LibraryApplication Scriptsio.fadel.Batteries.BatteriesTodayExtension",
    "~LibraryCachesio.fadel.Batteries",
    "~LibraryCachesio.fadel.Batteries.Helper",
    "~LibraryContainersio.fadel.Batteries.BatteriesTodayExtension",
    "~LibraryGroup ContainersKUC6B4JW25.io.fadel.Batteries",
    "~LibraryPreferencesio.fadel.Batteries.Helper.plist",
    "~LibraryPreferencesio.fadel.Batteries.plist",
  ]
end