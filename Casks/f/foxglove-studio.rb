cask "foxglove-studio" do
  version "1.85.0"
  sha256 "270a39a8c9e5a07e07d1477110214176e09391f3848705f74963d5c00505a65f"

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