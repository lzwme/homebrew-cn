cask "block-goose" do
  version "1.0.9"
  sha256 "2660d8cbc2352e3de889c5a80fec8d24181de2b18e03bec03feff57532994c3d"

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