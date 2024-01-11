cask "chia" do
  arch arm: "-arm64"

  version "2.1.4"
  sha256 arm:   "3268c67a9c6f7beccabed6d93c09b4bcef629343197ecd7777bcea13593f0016",
         intel: "89b611c786a5f23e9e981cab17bd1024532aa36bb9a505e8f863daaefb11ec33"

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