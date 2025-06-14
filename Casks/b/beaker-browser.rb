cask "beaker-browser" do
  version "1.1.0"
  sha256 "c88718c6ec1f7cbb70f33e3ac04f0d2117ab5b7907d9fa0529cd8b70f13df0e2"

  url "https:github.combeakerbrowserbeakerreleasesdownload#{version}beaker-browser-#{version}.dmg",
      verified: "github.combeakerbrowserbeaker"
  name "Beaker Browser"
  name "Beaker"
  desc "Experimental peer-to-peer web browser"
  homepage "https:beakerbrowser.com"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true

  app "Beaker Browser.app"

  zap trash: [
    "~LibraryApplication SupportBeaker Browser",
    "~LibraryApplication SupportCachesbeaker-browser-updater",
    "~LibraryCachescom.pfrazee.beaker-browser",
    "~LibraryCachescom.pfrazee.beaker-browser.ShipIt",
    "~LibraryPreferencescom.pfrazee.beaker-browser.plist",
    "~LibrarySaved Application Statecom.pfrazee.beaker-browser.savedState",
  ]
end