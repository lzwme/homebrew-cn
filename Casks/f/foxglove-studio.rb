cask "foxglove-studio" do
  version "1.82.0"
  sha256 "1c9b1320c7d99d461504d9e89fba5f350d440cf194824509d8f88c302d660bad"

  url "https:github.comfoxglovestudioreleasesdownloadv#{version}foxglove-studio-#{version}-mac-universal.dmg",
      verified: "github.comfoxglovestudio"
  name "Foxglove Studio"
  desc "Visualization and debugging tool for robotics"
  homepage "https:foxglove.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Foxglove Studio.app"

  zap trash: [
    "~LibraryApplication Scriptsdev.foxglove.studio.quicklook",
    "~LibraryApplication SupportFoxglove Studio",
    "~LibraryCachesdev.foxglove.studio",
    "~LibraryCachesdev.foxglove.studio.ShipIt",
    "~LibraryContainersdev.foxglove.studio.quicklook",
    "~LibraryPreferencesdev.foxglove.studio.plist",
    "~LibrarySaved Application Statedev.foxglove.studio.savedState",
  ]
end