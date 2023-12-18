cask "vysor" do
  version "5.0.7"
  sha256 "b3db71a61e6b46df7242038335b0ff6be961fcfd3e31250fda0488236bcadd6f"

  url "https:github.comkoushvysor.ioreleasesdownloadv#{version}Vysor-mac-#{version}.zip",
      verified: "github.comkoushvysor.io"
  name "Vysor"
  desc "Mirror and control your phone"
  homepage "https:www.vysor.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Vysor.app"

  zap trash: [
    "~LibraryApplication SupportVysor",
    "~LibraryCachescom.electron.vysor",
    "~LibraryCachescom.electron.vysor.ShipIt",
    "~LibraryPreferencescom.electron.vysor.helper.plist",
    "~LibraryPreferencescom.electron.vysor.plist",
    "~LibrarySaved Application Statecom.electron.vysor.savedState",
  ]
end