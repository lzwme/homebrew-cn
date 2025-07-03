cask "tuist" do
  version "4.55.5"
  sha256 "137deacd09e006637a05a5859ab7ed31adae10039f02d2f9cacc488f00cf2092"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end