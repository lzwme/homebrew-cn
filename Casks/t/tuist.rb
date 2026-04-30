cask "tuist" do
  version "4.191.1"
  sha256 "53792847193cff79ba0176a88f2f990fa62216f878a5ce41981a12cc95fd3c57"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end