cask "tuist" do
  version "4.42.0"
  sha256 "d98f5e7bca1c4e955b705e221c33b7ad3dff4ea01263ec5d9e8260c918482a46"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end