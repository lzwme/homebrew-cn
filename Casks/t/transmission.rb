cask "transmission" do
  version "4.0.6"
  sha256 "e69857f152e0c2f5384cc603586c3dff2c30c93e674263346a702863e7277c1a"

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
  conflicts_with cask: "transmission@nightly"

  app "Transmission.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.m0k.transmission.sfl*",
    "~LibraryApplication SupportTransmission",
    "~LibraryCachescom.apple.helpdSDMHelpDataOtherEnglishHelpSDMIndexFileorg.m0k.transmission.help",
    "~LibraryCachescom.apple.helpdSDMHelpDataOtherEnglishHelpSDMIndexFileTransmission Help*",
    "~LibraryCachesorg.m0k.transmission",
    "~LibraryCookiesorg.m0k.transmission.binarycookies",
    "~LibraryPreferencesorg.m0k.transmission.LSSharedFileList.plist",
    "~LibraryPreferencesorg.m0k.transmission.plist",
    "~LibrarySaved Application Stateorg.m0k.transmission.savedState",
  ]
end