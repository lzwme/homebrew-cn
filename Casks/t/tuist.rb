cask "tuist" do
  version "4.47.0"
  sha256 "17eb3bd35e3422973e658002db3c6f8ebfb1c69aca5f1aa278375f6c5fdabdea"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end