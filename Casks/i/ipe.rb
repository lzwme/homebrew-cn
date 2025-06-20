cask "ipe" do
  arch arm: "arm", intel: "intel"

  version "7.2.29"
  sha256 arm:   "25afb5d6bd0f4f51e27823d86de470d6caa7600e8ee5111f633fa10879904b8c",
         intel: "8bfb970614be423f1bf716217be3db6faa4676c5fa55a51ef81a2e3c6d6edc4d"

  url "https:github.comotfriedipereleasesdownloadv#{version}ipe-#{version}-mac-#{arch}.dmg",
      verified: "github.comotfriedipe"
  name "Ipe"
  desc "Drawing editor for creating figures in PDF format"
  homepage "https:ipe.otfried.org"

  livecheck do
    url :homepage
    regex(href=.*?ipe[._-](\d+(?:\.\d+)+)[._-]mac[._-]#{arch}\.dmgi)
  end

  no_autobump! because: :requires_manual_review

  app "Ipe.app"

  zap trash: [
    "~.ipe",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.otfried.ipe.ipe.sfl*",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.otfried.ipe.sfl*",
    "~LibraryPreferencesorg.otfried.ipe.Ipe.plist",
    "~LibrarySaved Application Stateorg.otfried.ipe.savedState",
  ]
end