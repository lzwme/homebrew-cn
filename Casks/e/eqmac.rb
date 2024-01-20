cask "eqmac" do
  version "1.8.3"
  sha256 "17e9b3e948d5cf3121bf427fd9121d9d730624f19a5d9a9fa03c2300708d51b3"

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