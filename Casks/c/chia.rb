cask "chia" do
  arch arm: "-arm64"

  version "2.5.3"
  sha256 arm:   "86ab2f52e8311a82d03eefb22a30e83a19f15c3c5388c64025951c021e23d3d2",
         intel: "5ae33a980b9e3fdb55a51d6847c9a99e6ac9d0a877565ef5d12bf4cadb785311"

  url "https:github.comChia-Networkchia-blockchainreleasesdownload#{version}Chia-#{version}#{arch}.dmg",
      verified: "github.comChia-Networkchia-blockchain"
  name "Chia Blockchain"
  desc "GUI Python implementation for the Chia blockchain"
  homepage "https:www.chia.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Chia.app"

  zap trash: [
    "~.chia",
    "~LibraryApplication SupportChia Blockchain",
    "~LibraryPreferencesnet.chia.blockchain.plist",
    "~LibrarySaved Application Statenet.chia.blockchain.savedState",
  ]
end