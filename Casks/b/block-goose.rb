cask "block-goose" do
  version "1.0.12"
  sha256 "eb7e74596476b27dcae56983bc9e2983adb41a805ab3e10d8cfeb10c613cb50a"

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