cask "blockbench" do
  arch arm: "arm64", intel: "x64"

  version "4.12.4"
  sha256 arm:   "37fe99f7c404d029c257bd28a93f6f7513c2bbe90e78b43963960600d6ac7e82",
         intel: "e397c101d522263b3ecdee8f1a7532d5e862aa0cb4d86280eea81f18a6a7d2f4"

  url "https:github.comJannisX11blockbenchreleasesdownloadv#{version}Blockbench_#{arch}_#{version}.dmg",
      verified: "github.comJannisX11blockbench"
  name "Blockbench"
  desc "3D model editor for boxy models and pixel art textures"
  homepage "https:www.blockbench.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Blockbench.app"

  zap trash: [
    "~LibraryApplication SupportBlockbench",
    "~LibraryPreferencesblockbench.plist",
    "~LibrarySaved Application Stateblockbench.savedState",
  ]
end