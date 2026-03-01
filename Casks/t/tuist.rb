cask "tuist" do
  version "4.153.0"
  sha256 "ea7e904f98975d59011e722c401e0ad9b09b11a4291519f1b0baabf1f6ff673b"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  binary "tuist"

  zap trash: "~/.tuist"
end