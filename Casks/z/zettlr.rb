cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.4.2"
  sha256 arm:   "9144639ffa889ba53c1583a1abd118a9a46635498e750abf02bd75955051c598",
         intel: "93e4b02df5d2270da99659ed0536ed03513dcc3378b1ea41b38c10778d0e2e2e"

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