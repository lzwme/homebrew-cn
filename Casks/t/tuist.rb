cask "tuist" do
  version "4.38.1"
  sha256 "19b148db8fb952c3e21b75aa2509a0a242733cbd3e63b346459d0fa9f7e5de57"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end