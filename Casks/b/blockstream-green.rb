cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.4"
  sha256 arm:   "290e829121f6fdb355eb4c9841af782e12bb4e670516ef9463fe3242dc1e647c",
         intel: "71c12fae521f6346c9817f902cc1872490cdfe180e4a085b4ca34e44129f75fe"

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