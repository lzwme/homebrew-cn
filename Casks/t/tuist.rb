cask "tuist" do
  version "4.2.5"
  sha256 "b41cb8fa458e9cb1642e3b6ecd35be5ee9aae0ad0bf55dd095694c91ce49d2ab"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end