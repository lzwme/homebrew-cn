cask "tuist" do
  version "4.4.0"
  sha256 "7f8365e86b9a8e47a6fbd10de6cc6f83d1ea1285cff80ad76505e21532ad3430"

  url "https:github.comtuisttuistreleasesdownload#{version}tuist.zip",
      verified: "github.comtuisttuist"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https:tuist.io"

  binary "tuist"

  zap trash: "~.tuist"
end