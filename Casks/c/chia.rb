cask "chia" do
  arch arm: "-arm64"

  version "2.2.0"
  sha256 arm:   "12895bb242b84f2a1fca2a91f377eab04f1ee39e5d07ffcc739c3f6723108c4f",
         intel: "040b52eca9b0e215cb2da4a5df6b4cd850633fd7e3bb9782778b15cff5b8dd49"

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
    "~.chia",
    "~LibraryApplication SupportChia Blockchain",
    "~LibraryPreferencesnet.chia.blockchain.plist",
    "~LibrarySaved Application Statenet.chia.blockchain.savedState",
  ]
end