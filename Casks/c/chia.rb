cask "chia" do
  arch arm: "-arm64"

  version "2.4.1"
  sha256 arm:   "79eab218e08f46141acbbb9087add47214cab293412574409cf5e009f4e7e408",
         intel: "c25c6e00acea915f91dda707465a2a0777cc425d9c555a0ec9392ccea23961e9"

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