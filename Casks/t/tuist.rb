cask "tuist" do
  version "4.50.2"
  sha256 "dd21c3852bffad6e904818c455b116070bf8751a1b2773d965787371e7237df0"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end