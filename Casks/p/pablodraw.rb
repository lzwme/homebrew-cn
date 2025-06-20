cask "pablodraw" do
  version "3.2.1"
  sha256 "91a89ac33ba3e064a7a2b44d5c7c271cbd1303882874e7ce159b8fb058589301"

  url "https:github.comcwensleypablodrawreleasesdownload#{version}PabloDrawMac-#{version}.zip"
  name "PabloDraw"
  desc "AnsiAscii text and RIPscrip editorviewer"
  homepage "https:github.comcwensleypablodraw"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-07-16", because: "is 32-bit only"

  app "PabloDraw.app"

  zap trash: [
    "~LibraryApplication Supportca.picoe.pablodraw",
    "~LibraryPreferencesca.picoe.pablodraw.plist",
    "~LibrarySaved Application Stateca.picoe.pablodraw.savedState",
  ]
end