cask "goxel" do
  version "0.12.0"
  sha256 "2a98f6eb441a10209ac9e4e99650afdeebc6dd5d54de39929b79f15b4cbc6e2f"

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