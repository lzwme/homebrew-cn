cask "eqmac" do
  version "1.8.4"
  sha256 "d5d07708982361ce10d28101e51efd03120464ce20bab2f1d1c9e0e38a245ce9"

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