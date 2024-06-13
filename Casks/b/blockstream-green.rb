cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.7"
  sha256 arm:   "42730aadef276499385b19e79cfcb5c3c8f7258a46171a557dc695d20c060352",
         intel: "53e6a54355152a91e54ea4fb3ba458e7376206674176baed57a2d99e19a7f69d"

  url "https:github.comBlockstreamgreen_qtreleasesdownloadrelease_#{version}BlockstreamGreen-#{arch}.dmg",
      verified: "github.comBlockstreamgreen_qt"
  name "Blockstream Green"
  desc "Multi-platform Bitcoin and Liquid wallet"
  homepage "https:blockstream.comgreen"

  app "Blockstream Green.app"

  zap trash: [
    "~LibraryApplication SupportBlockstreamGreen",
    "~LibraryCachesBlockstreamGreen",
  ]
end