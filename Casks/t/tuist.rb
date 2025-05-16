cask "tuist" do
  version "4.50.1"
  sha256 "d533d3eceac73cd818a4191ee6e87059591e807c2540cf79298ab085676201fa"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end