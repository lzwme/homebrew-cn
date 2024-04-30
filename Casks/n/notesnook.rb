cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.0"
  sha256 arm:   "183634c33031e9c15c03207542afc0bd38b281eb79b48e5e2a1120d4ca9b8602",
         intel: "3affd1a7f5cd441dbafb2073f325f6b3af5b69a7e0cf1ba7acfb51f53ea66a8b"

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