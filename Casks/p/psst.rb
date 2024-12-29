cask "psst" do
  version "0.1.0,20241228.051436"
  sha256 :no_check

  url "https:nightly.linkjpochylapsstworkflowsbuildmainPsst.dmg.zip",
      verified: "nightly.linkjpochylapsstworkflowsbuildmain"
  name "Psst"
  desc "Spotify client"
  homepage "https:github.comjpochylapsst"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "Psst.app"

  zap trash: [
    "~LibraryApplication SupportPsst",
    "~LibraryCachescom.jpochyla.psst",
    "~LibraryCachesPsst",
    "~LibraryHTTPStoragescom.jpochyla.psst",
    "~LibrarySaved Application Statecom.jpochyla.psst.savedState",
  ]
end