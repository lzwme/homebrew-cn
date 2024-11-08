cask "tuist" do
  version "4.33.0"
  sha256 "4b0dab1a80fc29f7e5624be69cc438e019dbd994682267c26f2583c082c075b2"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end