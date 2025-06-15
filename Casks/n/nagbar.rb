cask "nagbar" do
  version "1.3.7"
  sha256 "9a4b256250d4527423efd16e90cc7d087bc6ca9306bdc5267a6441194e73a44b"

  url "https:github.comvolendavidovNagBarreleasesdownload#{version}NagBar.zip",
      verified: "github.comvolendavidovNagBar"
  name "NagBar"
  desc "Status bar monitor for Nagios, Icinga2 and Thruk"
  homepage "https:sites.google.comsitenagbarapphome"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "NagBar.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.volendavidov.nagbar.sfl*",
    "~LibraryCachescom.volendavidov.NagBar",
    "~LibraryPreferencescom.volendavidov.NagBar.plist",
  ]

  caveats do
    requires_rosetta
  end
end