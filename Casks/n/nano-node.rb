cask "nano-node" do
  version "28.1"
  sha256 "be38f79e05daa5830d596d194c1472a93674d6afec3b2c525a5f98bb4a859e0c"

  url "https:github.comnanocurrencynano-nodereleasesdownloadV#{version}nano-node-V#{version}-Darwin.dmg",
      verified: "github.comnanocurrencynano-node"
  name "Nano"
  desc "Local node for the Nano cryptocurrency"
  homepage "https:nano.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Nano.app"

  zap trash: [
    "~LibraryPreferencesnet.raiblocks.rai_wallet.Nano.plist",
    "~LibraryRaiBlocks",
    "~LibrarySaved Application Statenet.raiblocks.rai_wallet.savedState",
  ]
end