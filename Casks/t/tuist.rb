cask "tuist" do
  version "4.8.0"
  sha256 "69d0f8e1a7dca5665217c71ace1f52b5443fad56f23acc26e3ff3cb6ec1413b3"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end