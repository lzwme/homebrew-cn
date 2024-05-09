cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.2"
  sha256 arm:   "c75283a6df339acabfcdca89d3c8b6a7208c1a54c37ecd22a91c10348a367026",
         intel: "26386e027bf31da643a4b8b7686defecb3cfd89b6230e03a98175acd2593c075"

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