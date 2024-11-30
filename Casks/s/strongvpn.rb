cask "strongvpn" do
  version "2.4.4,126629"
  sha256 "46176e645baa0b56a8920fc53e02ba9485353d6755365ff0085229a01504033b"

  url "https://static.colomovers.com/mac/StrongVPN_v#{version.csv.first}_b#{version.csv.second}.zip",
      verified: "static.colomovers.com/mac/"
  name "StrongVPN"
  desc "VPN app with support for multiple protocols"
  homepage "https://strongvpn.com/vpn-apps/macos/"

  livecheck do
    url "https://static.colomovers.com/mac/updates.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "StrongVPN.app"

  zap trash: [
    "~/Library/Application Support/com.strongvpn.StrongVPN2-Client",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.strongvpn.StrongVPN2-Client",
    "~/Library/Caches/com.strongvpn.StrongVPN2-Client",
    "~/Library/HTTPStorages/com.strongvpn.StrongVPN2-Client*",
    "~/Library/Preferences/com.strongvpn.StrongVPN2-Client.plist",
    "~/Library/Saved Application State/com.strongvpn.StrongVPN2-Client.savedState",
  ]
end