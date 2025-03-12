cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.21"
  sha256 arm:   "fe791815c5931f5c93910507084d8348d11e54cc2c0e5fc4045e58b9a0f2ca25",
         intel: "154d580d8ac3b4ce2bb673918da30242817c2d6b68db694d00abaa1040045448"

  url "https:github.comBlockstreamgreen_qtreleasesdownloadrelease_#{version}BlockstreamGreen-#{arch}.dmg",
      verified: "github.comBlockstreamgreen_qt"
  name "Blockstream Green"
  desc "Multi-platform Bitcoin and Liquid wallet"
  homepage "https:blockstream.comgreen"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Blockstream Green.app"

  zap trash: [
    "~LibraryApplication SupportBlockstreamGreen",
    "~LibraryCachesBlockstreamGreen",
  ]
end