cask "tuist" do
  version "4.44.3"
  sha256 "345cd256e56ce02f6f3a90801fa38952522e7159de4097c8b980ee67aaf6ad12"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end