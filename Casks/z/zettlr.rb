cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.2.1"
  sha256 arm:   "cfdc4be00eb316f408dbbea2eaa25c0c54c04185f6427d8a492c1371c0ff8087",
         intel: "bdf48dd5a82159e78910af78ba87d3495ef4ea2ad65af700970d48c593a47d01"

  url "https:github.comZettlrZettlrreleasesdownloadv#{version}Zettlr-#{version}-#{arch}.dmg"
  name "Zettlr"
  desc "Open-source markdown editor"
  homepage "https:github.comZettlrZettlr"

  depends_on macos: ">= :catalina"

  app "Zettlr.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.zettlr.app.sfl*",
    "~LibraryApplication Supportzettlr",
    "~LibraryLogsZettlr",
    "~LibraryPreferencescom.zettlr.app.plist",
    "~LibrarySaved Application Statecom.zettlr.app.savedState",
  ]
end