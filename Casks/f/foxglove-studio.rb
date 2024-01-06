cask "foxglove-studio" do
  version "1.83.1"
  sha256 "7b13fb24b1b256a0845f38547d48c92ec81e3a6ac79849414f7acf0a5fdb5fb5"

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