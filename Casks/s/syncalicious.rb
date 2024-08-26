cask "syncalicious" do
  version "0.0.6"
  sha256 "ff43d46269d18c8ac86f7d49f1abae8100f0b0852a594e88925b8e1bccd028f0"

  url "https:github.comzenangstSyncaliciousreleasesdownload#{version}Syncalicious.zip"
  name "Syncalicious"
  desc "Backup and synchronise preferences across multiple machines"
  homepage "https:github.comzenangstSyncalicious"

  depends_on macos: ">= :mojave"

  app "Syncalicious.app"

  uninstall quit: "com.zenangst.Syncalicious"

  zap trash: [
    "~LibraryCachescom.zenangst.Syncalicious",
    "~LibraryPreferencescom.zenangst.Syncalicious.plist",
    "~LibrarySaved Application Statecom.zenangst.Syncalicious.savedState",
  ]

  caveats do
    requires_rosetta
  end
end