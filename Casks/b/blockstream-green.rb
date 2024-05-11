cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.5"
  sha256 arm:   "68fdf1e89b6e28baa356418e93c9ade0c6a62dd1399e030d008ad5d7a80fcf4a",
         intel: "7f98190eb037d7682d5ed54954f07dbf9df14b44a3dca91bb108fd553fb3cc0d"

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