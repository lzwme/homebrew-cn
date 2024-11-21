cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.21"
  sha256 arm:   "e2e8057d70c0cf7344cfa100a5449e6103b3b8ee608d5c5d41b3f9fad382b725",
         intel: "512f2637974cb8d813433798b837f7eac1c1ed6f7b5f72e8581b32a1e2489d7b"

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