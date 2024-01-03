cask "foxglove-studio" do
  version "1.83.0"
  sha256 "f6932bb8a77d7ab4a33f0d10ae5dcf3347523963f81559c7ea7100f50432a40e"

  url "https:github.comfoxglovestudioreleasesdownloadv#{version}foxglove-studio-#{version}-mac-universal.dmg",
      verified: "github.comfoxglovestudio"
  name "Foxglove Studio"
  desc "Visualization and debugging tool for robotics"
  homepage "https:foxglove.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

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