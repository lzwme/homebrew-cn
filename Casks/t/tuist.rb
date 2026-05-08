cask "tuist" do
  version "4.192.0"
  sha256 "0b5f6325b3d88fce5db7240e2cedce3d7c9a6d05c051870bc04c83e8cf5cc3a8"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end