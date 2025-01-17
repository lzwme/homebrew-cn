cask "blockbench" do
  arch arm: "arm64", intel: "x64"

  version "4.12.1"
  sha256 arm:   "31e212460250764b5af8eb9ce17acf1ff681b886ffb5565f320bb484fff43608",
         intel: "4b40d500b217cbe0e39ef3d0fba38f51937c9bd0ae0a9e2412e9d369077e68a2"

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