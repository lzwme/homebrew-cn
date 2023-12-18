cask "eqmac" do
  version "1.8.0"
  sha256 "31929c47056deda005eb0f002abe5c302ca80e66527be5ad1f9a02b9a53ccc78"

  url "https:github.combitgappeqMacreleasesdownloadv#{version}eqMac.dmg",
      verified: "github.combitgappeqMac"
  name "eqMac"
  desc "System-wide audio equalizer"
  homepage "https:eqmac.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "eqMac.app"

  uninstall delete: "LibraryAudioPlug-InsHALeqMac.driver"

  zap trash: [
    "~LibraryCachescom.bitgapp.eqmac",
    "~LibraryPreferencescom.bitgapp.eqmac.plist",
    "~LibraryWebKitcom.bitgapp.eqmac",
  ]
end