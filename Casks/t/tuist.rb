cask "tuist" do
  version "4.21.2"
  sha256 "7c00de9e0d45de9b1071b84d81a4cb95010c807733676e065a2926db45e4fc88"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end