cask "tuist" do
  version "4.191.6"
  sha256 "e1db15cfcff9f1bdc4f9151a4a2018df32377ba53821d55bab8a4dfc8cdd608e"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end