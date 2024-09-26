cask "tuist" do
  version "4.28.0"
  sha256 "a691898eedb82ff74a8ffa570458d6c62ce3e65a115242e4bb5393edeb46e1fd"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end