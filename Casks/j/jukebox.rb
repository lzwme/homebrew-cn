cask "jukebox" do
  version "0.9.5"
  sha256 "51b939faee653015932fbe8cb32b9ac6d06482c3b3fdc73d9fb46ed67857ace7"

  url "https:github.comJaysceJukeboxreleasesdownloadv#{version}Jukebox.#{version}.dmg",
      verified: "github.comJaysceJukebox"
  name "Jukebox"
  desc "Menu bar song viewer"
  homepage "https:www.jaysce.devprojectsjukebox"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Jukebox.app"

  uninstall quit: "dev.jaysce.Jukebox"

  zap trash: [
    "~LibraryCachesdev.jaysce.Jukebox",
    "~LibraryHTTPStoragesdev.jaysce.Jukebox",
    "~LibraryPreferencesdev.jaysce.Jukebox.plist",
  ]
end