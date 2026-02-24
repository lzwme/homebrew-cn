cask "tuist" do
  version "4.151.1"
  sha256 "84d53a091f3df11c1fd0da857bdaca04cb2a109027e4a5dc8b7d86ff835478a6"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  binary "tuist"

  zap trash: "~/.tuist"
end