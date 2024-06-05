cask "tuist" do
  version "4.16.0"
  sha256 "ccc42fac66fcd208f01b731ed42467f13d2a5f560d90edd07aae94ba995f4a52"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end