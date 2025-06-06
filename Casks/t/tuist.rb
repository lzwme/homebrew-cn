cask "tuist" do
  version "4.52.0"
  sha256 "6f5dbb61ce18513346892cb0e3538a7c0412a4912dde8ad3ee60025d316d35a2"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end