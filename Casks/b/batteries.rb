cask "batteries" do
  version "2.3.3"
  sha256 "c04e1941026c449d878ad1eafafd08683a9ace7113ac4f1457d9efb9938316ad"

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