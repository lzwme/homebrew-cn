cask "multipatch" do
  version "2.0"
  sha256 "92d4077bc10802c7b4395d6716afc5c23bbdb34788be4a672fd5fef807a2072b"

  url "https:github.comSappharadMultiPatchreleasesdownload#{version}multipatch#{version.no_dots}.zip",
      verified: "github.comSappharadMultiPatch"
  name "MultiPatch"
  desc "File patching utility"
  homepage "https:projects.sappharad.commultipatch"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "MultiPatch.app"

  zap trash: [
    "~LibraryPreferencescom.sappharad.MultiPatch.plist",
    "~LibrarySaved Application Statecom.sappharad.MultiPatch.savedState",
  ]
end