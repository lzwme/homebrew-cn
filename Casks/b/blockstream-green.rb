cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.8"
  sha256 arm:   "f04d278a91332834bee4d9c021b24b589961a706d9e6cc4f529bbf1a34c1617a",
         intel: "37598de068d5849a887b6d3cf0402f0df5f44850190bda1b9853ae294e86c740"

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