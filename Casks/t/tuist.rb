cask "tuist" do
  version "4.31.0"
  sha256 "9099e708d1fc998a2f6515e9c07b28ee725f54ec174e0515c511ad644dca0c4c"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end