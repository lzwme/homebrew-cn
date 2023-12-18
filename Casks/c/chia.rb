cask "chia" do
  arch arm: "-arm64"

  version "2.1.2"
  sha256 arm:   "a3eb555794697cd63725758a7a487d0a5615a998dbc14432c2ecf549e06994aa",
         intel: "83d2a3f3d30dfec2c02a8d15553ead9b738a6aff7edcf06b86e467395979f3d1"

  url "https:github.comChia-Networkchia-blockchainreleasesdownload#{version}Chia-#{version}#{arch}.dmg",
      verified: "github.comChia-Networkchia-blockchain"
  name "Chia Blockchain"
  desc "GUI Python implementation for the Chia blockchain"
  homepage "https:www.chia.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Chia.app"

  zap trash: [
    "~LibraryApplication SupportChia Blockchain",
    "~LibraryPreferencesnet.chia.blockchain.plist",
    "~LibrarySaved Application Statenet.chia.blockchain.savedState",
    "~.chia",
  ]
end