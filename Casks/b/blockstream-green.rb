cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.25"
  sha256 arm:   "d0d659da3e6db7486b7e737c1e19b2931c6518903a6bc0e329ff557d1d9651e6",
         intel: "ef0d0e4baec3af3e80a044d17c9d7d7c6e66851bdbe57492b853d3b73d19588c"

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