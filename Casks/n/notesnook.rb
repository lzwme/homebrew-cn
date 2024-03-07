cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "2.6.16"
  sha256 arm:   "c2cb3af7ff8cbaf6b4c0223da3331360d1540b9156770af8291a8af1d832f0cf",
         intel: "b0bfb98301733afbcd17042592a1c6580b1c4ffead715edefbb59ad8c52ec6c8"

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