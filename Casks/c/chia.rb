cask "chia" do
  arch arm: "-arm64"

  version "2.4.2"
  sha256 arm:   "f0ed2a29a7bc721e289ac0297a2cfc562a81a9593a9f675cbe0d7395f1b20253",
         intel: "52b80b81ffbc456b9b5a00998fdc961b491b42cc63b28b97afb5d00402aaf39b"

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