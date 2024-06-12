cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.2.0"
  sha256 arm:   "e959763299d1798c0caa8e72797748feec379dac4ac0569be44c0ae1f5b0dc3d",
         intel: "ed7d8ab83547e63e8e9bfa32cfe1f8ddb6bc08f8ce12706148b69dcaf6843848"

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