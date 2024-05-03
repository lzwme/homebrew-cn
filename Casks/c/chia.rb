cask "chia" do
  arch arm: "-arm64"

  version "2.3.0"
  sha256 arm:   "a43c2876027febca803976575574ea0c032670985c1e3f810ad6080f25c7ad8d",
         intel: "7cbe3ff91a5e0684b827516dc049208ce4b71796118130d315a62ef9cd532ac3"

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