cask "slab" do
  arch arm: "arm64", intel: "x64"

  version "1.5.3"
  sha256 arm:   "f899111beaedba209aa11b64c3a52b6e3e8461bbc34722a919d8285f046ffe53",
         intel: "d307cec07640568c5dd6eccfed3be64e84794b222c23b3f6d8b91ebacdff2b0f"

  url "https:github.comslabdesktop-releasesreleasesdownloadv#{version}Slab-#{version}-darwin-#{arch}.dmg",
      verified: "github.comslabdesktop-releases"
  name "Slab"
  desc "Knowledge management for organisations"
  homepage "https:slab.com"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Slab.app"

  zap trash: [
    "~LibraryApplication SupportSlab",
    "~LibraryCachescom.slab.slab",
    "~LibraryCachescom.slab.slab.ShipIt",
    "~LibraryHTTPStoragescom.slab.slab",
    "~LibraryLogsSlab",
    "~LibraryPreferencescom.slab.slab.plist",
    "~LibrarySaved Application Statecom.slab.slab.savedState",
  ]
end