cask "batteries" do
  version "2.3.4"
  sha256 "8702e399198f30784b12b8805e7755fe96fac7cb88ed981c3e2266f913cbe4c9"

  url "https:github.comronyfadelBatteriesReleasesreleasesdownloadv#{version}Batteries.dmg",
      verified: "github.comronyfadelBatteriesReleases"
  name "Batteries"
  desc "Track all your devices' batteries"
  homepage "https:www.fadel.iobatteries"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

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