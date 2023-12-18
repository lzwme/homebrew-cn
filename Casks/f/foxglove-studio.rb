cask "foxglove-studio" do
  version "1.81.0"
  sha256 "112a3fdbe01f6b730507a9ba83628cc4d6f12bb43298e5f1e7d6e01ead43f750"

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