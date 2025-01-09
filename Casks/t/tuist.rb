cask "tuist" do
  version "4.39.0"
  sha256 "058070708354f4b8fa186e628b8e6ff018c7fff03cb717af5cd55cb8113b36f6"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end