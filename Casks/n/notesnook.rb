cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "2.6.15"
  sha256 arm:   "bfbacf9501901654590a20e93baeeed7abde7168fd128090cb63c6ca539d12de",
         intel: "5db218ee5b3b2b4950247132510c9f0201c389a78c8da81c24d6cd5b4ec08a0c"

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