cask "block-goose" do
  version "1.0.14"
  sha256 "7aa421e63c40e5b2d20d1523576c06de390f0fba037ef98d966c2fe12e0f0f44"

  url "https:github.comblockgoosereleasesdownloadv#{version}Goose.zip",
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