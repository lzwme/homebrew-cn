cask "tuist" do
  version "4.188.3"
  sha256 "58656a1ac283bd4b2748462ae5da945bdff6a3a3191c4548e5f6369f84a9c925"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end