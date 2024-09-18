cask "goxel" do
  version "0.15.1"
  sha256 "5a9213166e77bbb80f839499943af37524f5866f37d1948bcaddf9a3fec8f27a"

  url "https:github.comguillaumechereaugoxelreleasesdownloadv#{version}goxel-#{version}-mac.zip",
      verified: "github.comguillaumechereaugoxel"
  name "Goxel"
  desc "Open Source Voxel Editor"
  homepage "https:goxel.xyz"

  app "Goxel.app"

  zap trash: [
    "~LibraryApplication SupportGoxel",
    "~LibraryPreferencescom.noctuasoftware.goxel.plist",
    "~LibrarySaved Application Statecom.noctuasoftware.goxel.savedState",
  ]
end