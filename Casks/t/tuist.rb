cask "tuist" do
  version "4.0.0"
  sha256 "3921ff5bd933e70683825c3fd394807ed2e6c9afbdab02e14a5db39bf76f51c7"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end