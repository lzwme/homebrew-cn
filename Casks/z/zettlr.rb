cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.0.5"
  sha256 arm:   "b94090ac66458b8dd08ed0805c1d14e7d9bdf9fd337be2a86ce8ad793cfb00cd",
         intel: "7f29702fcf0f0c458e0c6bcf00e88c712d9c5f85d2b9883dd9c7f5aed29c651b"

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