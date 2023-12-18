cask "termhere" do
  version "1.2.1"
  sha256 "8311c29b09f982ce829d5733865c715f4f457d0a46dcab2beb18462a73a37b9d"

  url "https:github.comhbangTermHerereleasesdownload#{version}TermHere.#{version}.dmg",
      verified: "github.comhbangTermHere"
  name "TermHere"
  desc "Finder extension for opening a terminal from the current directory"
  homepage "https:hbang.wsappstermhere"

  app "TermHere.app"

  zap trash: [
    "~LibraryApplication SupportCrashReporterTermHere Finder Extension*",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsws.hbang.termhere.sfl*",
    "~LibraryCachesws.hbang.TermHere",
    "~LibraryContainersws.hbang.TermHere.TermHere-Finder-Extension",
    "~LibraryCookiesws.hbang.TermHere.binarycookies",
    "~LibraryGroup Containers*.group.ws.hbang.TermHere",
    "~LibraryLogsDiagnosticReportsTermHere Finder Extension*",
    "~LibraryPreferencesws.hbang.TermHere.plist",
  ]

  caveats do
    discontinued
  end
end