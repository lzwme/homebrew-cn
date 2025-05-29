cask "chia" do
  arch arm: "-arm64"

  version "2.5.4"
  sha256 arm:   "85ee484ff52bcc2aedf994425494dca81512737562d4b377a059556c4f3ac0b7",
         intel: "1e31a988ce46f1e298cb7cd544180928825da7cd50b21f78c5b36f23d8cbc567"

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