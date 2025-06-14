cask "geotag-photos-pro" do
  version "1.9.7"
  sha256 "4cf4414fad5c9c472f8c334b543868d8d6b9d0a3a90736285dd2ec0be3ee3238"

  url "https:github.comtappytapsgeotag-desktop-appreleasesdownloadv#{version}Geotag-Photos-Pro-2-#{version}.dmg",
      verified: "github.comtappytapsgeotag-desktop-app"
  name "Geotag Photos Pro"
  desc "Geotagging software"
  homepage "https:www.geotagphotos.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Geotag Photos Pro 2.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.tappytaps.geotagphotosdesktop.sfl*",
    "~LibraryApplication SupportGeotag Photos Pro*",
    "~LibraryLogsGeotag Photos Pro*",
    "~LibraryPreferencescom.tappytaps.geotagphotosdesktop.plist",
    "~LibrarySaved Application Statecom.tappytaps.geotagphotosdesktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end