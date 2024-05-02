cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.1"
  sha256 arm:   "c8c2d3d30da1b2cc94774fb4bd783f7357f804c318ba290dc3c899bacb93ddf5",
         intel: "9060972f44beb8eb510a2d9344db31e470f5e4c56505574aee6f0cf9a830f56a"

  url "https:github.comstreetwritersnotesnookreleasesdownloadv#{version}notesnook_mac_#{arch}.dmg",
      verified: "github.comstreetwritersnotesnook"
  name "Notesnook"
  desc "Privacy-focused note taking app"
  homepage "https:notesnook.com"

  livecheck do
    url "https:notesnook.comreleasesdarwinlatest-mac.yml"
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