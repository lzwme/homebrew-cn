cask "batteries" do
  version "2.2.9"
  sha256 "9f67e1451bb406e9a14d514cd8a032252ef671d359cbffd3a47d4b80f015a9f6"

  url "https:github.comronyfadelBatteriesReleasesreleasesdownloadv#{version}Batteries.dmg",
      verified: "github.comronyfadelBatteriesReleases"
  name "Batteries"
  desc "Track all your devices' batteries"
  homepage "https:www.fadel.iobatteries"

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