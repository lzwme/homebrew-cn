cask "tuist" do
  version "4.10.2"
  sha256 "8af32992bc2f809097ce5ed2c423b95989470ca4ccf16ee339d6800d0edc479d"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end