cask "tuist" do
  version "4.43.0"
  sha256 "696da7c820a8de2c587a8f4b4f71d253785e9258b4dc152445bead975ac98132"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end