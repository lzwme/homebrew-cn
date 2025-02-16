cask "chia" do
  arch arm: "-arm64"

  version "2.5.1"
  sha256 arm:   "d12635f28e21fbfa89683b4bc7958aa9934d5f7de5f8336021c1e88fc619aae2",
         intel: "f094b242c3473a626d3e794810d356b129da74a716bc8797d26a5dba19f7fea4"

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