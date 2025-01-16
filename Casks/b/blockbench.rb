cask "blockbench" do
  arch arm: "arm64", intel: "x64"

  version "4.12.0"
  sha256 arm:   "2b1268f0c70df28c1de49c4761550711ad5b099975455fc39e426615c98b48b7",
         intel: "77157d3b8fae355294d8f599bb40d04c7ea6c239e8d834548a4665e4957ce89e"

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