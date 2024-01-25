cask "eqmac" do
  version "1.8.5"
  sha256 "f5fcfbf0f8a25091190e7a1aa98a8349b70b7774a697a9c6dba763732523658b"

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