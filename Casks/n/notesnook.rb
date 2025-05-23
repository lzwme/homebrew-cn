cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.1.1"
  sha256 arm:   "1fedf22ffec1d47a12064afa7a8ba902a3e85c3979b76cc6023a5554eb27d66f",
         intel: "642a0c3fd709b956637c5a6c974b0780cf3006b443d095568bb4c601a11080ad"

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
  depends_on macos: ">= :sierra"

  app "Notesnook.app"

  zap trash: [
    "~LibraryApplication SupportNotesnook",
    "~LibraryLogsNotesnook",
    "~LibraryPreferencescom.streetwriters.notesnook.plist",
  ]
end