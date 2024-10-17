cask "tuist" do
  version "4.30.0"
  sha256 "b761881f5f7b6188ac8de62c9887775eec148fb6c8e3b982db281d353a300542"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end