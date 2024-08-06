cask "tuist" do
  version "4.23.0"
  sha256 "27172a7228e082d977cbd11f2dc15acb360a2c8a479cc04501c15d8a3e53b0ad"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end