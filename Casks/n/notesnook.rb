cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.9"
  sha256 arm:   "3f28ce12c98d9f6ab28964e29083d994499c08669cd0c1195af53193454a7080",
         intel: "859ea2236e5081cbc7245950442651e8794c89e1884195ed78aed686e6d8c2f1"

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