cask "chia" do
  arch arm: "-arm64"

  version "2.4.4"
  sha256 arm:   "eeb70395449b8a0563c71d230d3bc1beb4383d4f7ceeab58dbf0289bdcb25c6a",
         intel: "8da1a7eca0f767470b67588fad59199fa9170ac92ea60e039b76414c79c2ebd6"

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