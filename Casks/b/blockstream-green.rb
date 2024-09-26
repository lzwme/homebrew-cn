cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.11"
  sha256 arm:   "2eb1ddec346377f32fd9baedb211aa0a624b84041a8766397774eec5c6ef3b69",
         intel: "5724f542c2175b51150b699e2f4db406d58ee518592f94b9824c3213fa13c96d"

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