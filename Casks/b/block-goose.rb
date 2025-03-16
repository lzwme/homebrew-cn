cask "block-goose" do
  arch intel: "_intel_mac"

  version "1.0.14"
  sha256 arm:   "7aa421e63c40e5b2d20d1523576c06de390f0fba037ef98d966c2fe12e0f0f44",
         intel: "1c9b2edd8a428e760b3d1e3b5a58aa9f8f67c14c4f0fe16828a42501998a01e5"

  url "https:github.comblockgoosereleasesdownloadv#{version}Goose#{arch}.zip",
      verified: "github.comblockgoose"
  name "Goose"
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :big_sur"

  app "Goose.app"

  zap trash: "~LibraryApplication SupportGoose"
end