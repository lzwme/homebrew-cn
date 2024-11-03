cask "blockbench" do
  arch arm: "arm64", intel: "x64"

  version "4.11.2"
  sha256 arm:   "5ce158ddf62ab17e060f3cd9061fff2ebd445d8de311776beac94a37c2fbeddb",
         intel: "90bf713441436fc7a01a62f716bc08371b6d48a16fd135bb49028c641529e60e"

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