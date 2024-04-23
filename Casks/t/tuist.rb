cask "tuist" do
  version "4.10.1"
  sha256 "ac5425e528471af0fe865e5fbb84b1acc170985af2882a516b671a38d0928462"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end