cask "dockstation" do
  version "1.5.1"
  sha256 "3449009fcd2fc8476381d4de62b2086999281ede81f903dfb63715c3383491c7"

  url "https:github.comDockStationdockstationreleasesdownloadv#{version}dockstation-#{version}.dmg",
      verified: "github.comDockStationdockstation"
  name "DockStation"
  homepage "https:dockstation.io"

  depends_on macos: ">= :el_capitan"

  app "DockStation.app"

  zap trash: [
    "~LibraryApplication Supportdockstation",
    "~LibraryPreferencesorg.dockstation.DockStation.helper.plist",
    "~LibraryPreferencesorg.dockstation.DockStation.plist",
    "~LibrarySaved Application Stateorg.dockstation.DockStation.savedState",
  ]
end