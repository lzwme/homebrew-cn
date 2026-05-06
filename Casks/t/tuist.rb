cask "tuist" do
  version "4.191.8"
  sha256 "0bd2ca2bf8e0d59d88145628acc710f8ac2dcd86087d8c1d0cc9702d7d7d0b5e"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end