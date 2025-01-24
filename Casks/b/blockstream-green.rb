cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.18"
  sha256 arm:   "99b80b865f9477d18f7a02edd09f9a1072c135e0e3f990134efac4bbb387d019",
         intel: "19d397cd0557563f959be0b83466f0193464e26026b363767dd39fc88a093bc2"

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