cask "tuist" do
  version "4.53.0"
  sha256 "de8c4adb241912e502ce02aa98c8fd9ef57fb52cdbff641e88922d3e1735da4f"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end