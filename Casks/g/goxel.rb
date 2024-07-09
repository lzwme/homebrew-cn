cask "goxel" do
  version "0.15.0"
  sha256 "e265cbf9789260fd0776ccccbad5e5784cf299fcd4f6c0c957be6880c5b1c78c"

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