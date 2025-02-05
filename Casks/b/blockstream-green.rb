cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.20"
  sha256 arm:   "94196c8901ca5c7ccb253f879b45eb4e1e0094ab4e48941d1040621bdc66e9ef",
         intel: "f064bb7283322535702620c3d38ae3c42aae50cb7ce8f5aa1542c4ded894df92"

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