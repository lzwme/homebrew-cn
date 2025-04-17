cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.4.4"
  sha256 arm:   "7003a726ccd35b9c9c6bf0f8c321161ff6cbdcc63bed7ecccf001f4103c1eaa9",
         intel: "cfefb7016e1e1a81e073f0e6d04aeef622593cc70fcb5403462ef7fc54dbc920"

  url "https:github.comZettlrZettlrreleasesdownloadv#{version}Zettlr-#{version}-#{arch}.dmg"
  name "Zettlr"
  desc "Open-source markdown editor"
  homepage "https:github.comZettlrZettlr"

  depends_on macos: ">= :big_sur"

  app "Zettlr.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.zettlr.app.sfl*",
    "~LibraryApplication Supportzettlr",
    "~LibraryLogsZettlr",
    "~LibraryPreferencescom.zettlr.app.plist",
    "~LibrarySaved Application Statecom.zettlr.app.savedState",
  ]
end