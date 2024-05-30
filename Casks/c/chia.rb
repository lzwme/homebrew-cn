cask "chia" do
  arch arm: "-arm64"

  version "2.3.1"
  sha256 arm:   "c3912ab12b2dc7036886bab1eb7b1a8fa1affc92d9f156b4f4b97fd0c87e39db",
         intel: "afdc4c18bd5fec4f9e7843fccdec22f38d1a7c8a052dce3f7225e0c0bafe1c76"

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