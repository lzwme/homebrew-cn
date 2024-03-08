cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.1"
  sha256 arm:   "efb4e3ff118e93e6e174cdda3579092bd7c910ca7946ce97f03726b0958eb08f",
         intel: "7e7785e3905ff1a04cdbd075dfcbfeb00aa8da0321eec3e0cac81877e072f736"

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