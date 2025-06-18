cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.2.0"
  sha256 arm:   "15ebcbddcbb6ca19467427b73f27bb11fe2a50e78275ffcbab79e208bfca8f85",
         intel: "07460b17d1d20a18c9c6c291ad5d357fb132eb61a719b27e409a1fbf65b30d02"

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