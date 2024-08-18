cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.9"
  sha256 arm:   "4e61287865f63f6d9f209203837bb0239203a265ed4de3616a3dfce13235b7c4",
         intel: "d726d0cfdf62c53a63d00bee2cd2d7a7f6cb8877a83b2fbe0a085679c2bb2b6d"

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