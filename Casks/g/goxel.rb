cask "goxel" do
  version "0.14.0"
  sha256 "d195f3ef9aa38fb2346b156a17a10f2625a531bf4ffdd02675a8b302a7ee84fe"

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