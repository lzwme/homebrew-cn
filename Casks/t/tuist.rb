cask "tuist" do
  version "4.1.1"
  sha256 "835f6574d70226580bbd3dc1194f6123318945c73b95af86079264d9d4ddb390"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end