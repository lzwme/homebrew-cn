cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.2"
  sha256 arm:   "c02896252de852b6148f89b92a6e1a2655c364ede9af3309a2919be3b0395636",
         intel: "dfa3243875d6ae28d5525b7e8bbe4805f600b28442195f2b395f25065518a14a"

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