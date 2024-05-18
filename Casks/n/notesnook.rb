cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.6"
  sha256 arm:   "266eeb65612c32ca632ab30e0c63c11893f42397c5dda8fe59774136c9afe23c",
         intel: "03445b9ba6e8608d81dcd7be15ccc0337aa6b4cd8ac0d583f82d8dd2c81646d8"

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