cask "psst" do
  version :latest
  sha256 :no_check

  url "https:github.comjpochylapsstreleaseslatestdownloadPsst.dmg"
  name "Psst"
  desc "Spotify client"
  homepage "https:github.comjpochylapsst"

  depends_on macos: ">= :big_sur"

  app "Psst.app"

  zap trash: [
    "~LibraryApplication SupportPsst",
    "~LibraryCachescom.jpochyla.psst",
    "~LibraryCachesPsst",
    "~LibraryHTTPStoragescom.jpochyla.psst",
    "~LibraryPreferencescom.jpochyla.psst.plist",
    "~LibrarySaved Application Statecom.jpochyla.psst.savedState",
  ]
end