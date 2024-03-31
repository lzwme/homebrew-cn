cask "blockstream-green" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.3"
  sha256 arm:   "1531938cad0a5f458eaa0e3dc04860622876eb2bbf2e521312735a8a1374e061",
         intel: "12acba25e9a3607e72b3849bef59e6cc15fa2bae8468630daf454dcd139c91e8"

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