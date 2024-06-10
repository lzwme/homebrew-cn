cask "batteries" do
  version "2.2.8"
  sha256 "f7fce2db2466fa46afd30fcc09ca0269ee7727583776355b376aa409fb39c191"

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