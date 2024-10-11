cask "tuist" do
  version "4.29.1"
  sha256 "ace5d6efec615d5c524d065fd42757f77ef4d5770a2109a8707720871ddadbf1"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end