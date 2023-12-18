cask "ipe" do
  arch arm: "arm", intel: "intel"

  version "7.2.28"
  sha256 arm:   "920a6ab47c3fd6a9d5e9a530d3a1d288d282d5dc9227383d3bf6e75307b1faa9",
         intel: "2de5402c14cc8bbfcc3f6ea45a3712c5cfac928aeabf506d0673aecbb6884ff7"

  url "https:github.comotfriedipereleasesdownloadv#{version}ipe-#{version}-mac-#{arch}.dmg",
      verified: "github.comotfriedipe"
  name "Ipe"
  desc "Drawing editor for creating figures in PDF format"
  homepage "https:ipe.otfried.org"

  livecheck do
    url :homepage
    regex(href=.*?ipe[._-](\d+(?:\.\d+)+)[._-]mac[._-]#{arch}\.dmgi)
  end

  app "Ipe.app"

  zap trash: [
    "~.ipe",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.otfried.ipe.ipe.sfl*",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.otfried.ipe.sfl*",
    "~LibraryPreferencesorg.otfried.ipe.Ipe.plist",
    "~LibrarySaved Application Stateorg.otfried.ipe.savedState",
  ]
end