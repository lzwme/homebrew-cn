cask "nano" do
  version "27.1"
  sha256 "9c0ef9d3f33c8bdae157332d3d0028e608d722f1ad141a952a504398b8e972ba"

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