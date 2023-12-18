cask "nano" do
  version "25.1"
  sha256 "ef05a7d200685e3e20eea1235122abdea49f917b547e19cef4daff26020eeb6f"

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