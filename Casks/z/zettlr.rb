cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.2.3"
  sha256 arm:   "1f75677a6a68f87b13e5d2cdfc31a5901f65401d8065ee3657cf564c4231c2ff",
         intel: "00d3a137f21bf8f49a59f1c530ae587ccbdc79949ebb7d699852a7a15fe95a96"

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