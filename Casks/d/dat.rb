cask "dat" do
  version "3.0.1"
  sha256 "f6c89150f72568c2de1f42653bca0fa356cbb24704f31f1ef5e11f75b0095866"

  url "https:github.comdat-ecosystem-archivedat-desktopreleasesdownloadv#{version}dat-desktop-#{version}-mac.zip",
      verified: "github.comdat-ecosystem-archivedat-desktop"
  name "Dat Desktop"
  desc "Peer to peer data sharing app built for humans"
  homepage "https:dat-ecosystem.org"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Dat Desktop.app"

  zap trash: [
    "~LibraryApplication SupportDat",
    "~LibraryCachescom.datproject.dat",
    "~LibraryCachescom.datproject.dat.ShipIt",
    "~LibraryPreferencescom.datproject.dat.helper.plist",
    "~LibraryPreferencescom.datproject.dat.plist",
    "~LibrarySaved Application Statecom.datproject.dat.savedState",
    "~.dat",
    "~.dat-desktop",
  ]
end