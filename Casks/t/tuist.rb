cask "tuist" do
  version "4.191.5"
  sha256 "40ed31fa657c30d1aff6b4cebf0cd9fb0aaa613b23aa29f589ec1790b7baf0f4"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end