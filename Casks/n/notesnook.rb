cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.2.2"
  sha256 arm:   "962c030dc81b544ea23ab17fe2a8eada2d460db001f2d454c058daacffc43624",
         intel: "840274584e717137168ff3a94380ee48532f7f2d2ffc72c217bb945a555b8d53"

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