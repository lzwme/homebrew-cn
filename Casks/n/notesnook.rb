cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.18"
  sha256 arm:   "8a15d86b9beaed2260a984e43f59ba6feea09cc5debee7e6b6228a8793eb6cfc",
         intel: "2239e41bff0247958c3f3ff4c45731bab81e3f7e4d5ebd519e162097540a98e8"

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