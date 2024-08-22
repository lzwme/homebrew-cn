cask "chia" do
  arch arm: "-arm64"

  version "2.4.3"
  sha256 arm:   "3253035075ef29e2b14c4fa1191bd2e9322ac215133698c713db3978fb7f7024",
         intel: "9fe775dbab95351412d1e3af0f95ed0bde7a77196e45413087f2bcc10de2281e"

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