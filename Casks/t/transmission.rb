cask "transmission" do
  version "4.0.5"
  sha256 "6a0e6838cb247ab1ed1390ef65368b82fc74b4e72cb0e291991f26c221436bc3"

  url "https:github.comtransmissiontransmissionreleasesdownload#{version}Transmission-#{version}.dmg",
      verified: "github.comtransmissiontransmission"
  name "Transmission"
  desc "Open-source BitTorrent client"
  homepage "https:transmissionbt.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "homebrewcask-versionstransmission-nightly"

  app "Transmission.app"

  zap trash: [
    "~LibraryApplication SupportTransmission",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.m0k.transmission.sfl*",
    "~LibraryCachescom.apple.helpdSDMHelpDataOtherEnglishHelpSDMIndexFileTransmission Help*",
    "~LibraryCachescom.apple.helpdSDMHelpDataOtherEnglishHelpSDMIndexFileorg.m0k.transmission.help",
    "~LibraryCachesorg.m0k.transmission",
    "~LibraryCookiesorg.m0k.transmission.binarycookies",
    "~LibraryPreferencesorg.m0k.transmission.LSSharedFileList.plist",
    "~LibraryPreferencesorg.m0k.transmission.plist",
    "~LibrarySaved Application Stateorg.m0k.transmission.savedState",
  ]
end