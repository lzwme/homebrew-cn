cask "tuist" do
  version "4.20.0"
  sha256 "eed98f50d99a9aa23aa26dfd3fd3a1a721c94a879ed11836d197f5557ccafdc8"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end