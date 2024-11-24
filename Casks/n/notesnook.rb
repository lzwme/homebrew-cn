cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.22"
  sha256 arm:   "1232549f4a56578ca2c7a82595b04ad19f46a066d56e92d12070d4e7f4999b9d",
         intel: "7ba93cd955d22e9b6cb415cfaca3510afcf6eaab5c4bae2f40e84e90756500ec"

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