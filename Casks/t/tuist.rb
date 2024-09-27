cask "tuist" do
  version "4.28.1"
  sha256 "f906487923538832a627e20dfd08fbf2552730c5eb6c7d1bc396c3a0b45a162e"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end