cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.5"
  sha256 arm:   "b893e7705271551888ff8cb48d0b700e6769480a8db15d043af19686180b6f4e",
         intel: "209b50fdabd16cb0d2bd16bc9134e66fdea2702d4cc48fbd86d49f32feb288bc"

  url "https:github.comstreetwritersnotesnookreleasesdownloadv#{version}notesnook_mac_#{arch}.dmg",
      verified: "github.comstreetwritersnotesnook"
  name "Notesnook"
  desc "Privacy-focused note taking app"
  homepage "https:notesnook.com"

  livecheck do
    url "https:notesnook.comapiv1releasesdarwinlatestlatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true

  app "Notesnook.app"

  zap trash: [
    "~LibraryApplication SupportNotesnook",
    "~LibraryLogsNotesnook",
    "~LibraryPreferencescom.streetwriters.notesnook.plist",
  ]
end