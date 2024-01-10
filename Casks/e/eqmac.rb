cask "eqmac" do
  version "1.8.2"
  sha256 "ad4ddc98c5eb89e075d102dd8125d15247f457d5d74ed9548e448f99eb0df136"

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