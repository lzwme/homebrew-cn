cask "nano" do
  version "28.0"
  sha256 "6fe839ea45176d9bf24556da5b767813d08723dbe8526426a600f7d12b553ae2"

  url "https:github.comnanocurrencynano-nodereleasesdownloadV#{version}nano-node-V#{version}-Darwin.dmg",
      verified: "github.comnanocurrencynano-node"
  name "Nano"
  desc "Local node for the Nano cryptocurrency"
  homepage "https:nano.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "Nano.app"

  zap trash: [
    "~LibraryPreferencesnet.raiblocks.rai_wallet.Nano.plist",
    "~LibraryRaiBlocks",
    "~LibrarySaved Application Statenet.raiblocks.rai_wallet.savedState",
  ]
end