cask "tuist" do
  version "4.43.1"
  sha256 "ec9c9b0ae75d4722886c2b6887e699628a3137f7fd6e769750b402d71ed242ea"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end