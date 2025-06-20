cask "dat" do
  version "3.0.1"
  sha256 "f6c89150f72568c2de1f42653bca0fa356cbb24704f31f1ef5e11f75b0095866"

  url "https:github.comdat-ecosystem-archivedat-desktopreleasesdownloadv#{version}dat-desktop-#{version}-mac.zip",
      verified: "github.comdat-ecosystem-archivedat-desktop"
  name "Dat Desktop"
  desc "Peer to peer data sharing app built for humans"
  homepage "https:dat-ecosystem.org"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Dat Desktop.app"

  zap trash: [
    "~.dat",
    "~.dat-desktop",
    "~LibraryApplication SupportDat",
    "~LibraryCachescom.datproject.dat",
    "~LibraryCachescom.datproject.dat.ShipIt",
    "~LibraryPreferencescom.datproject.dat.helper.plist",
    "~LibraryPreferencescom.datproject.dat.plist",
    "~LibrarySaved Application Statecom.datproject.dat.savedState",
  ]
end