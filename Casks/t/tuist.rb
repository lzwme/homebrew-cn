cask "tuist" do
  version "4.12.1"
  sha256 "f56cd6612b8edd30f868dc11db99a4e4835403fd81a451fd6ff38062f4178cc2"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end