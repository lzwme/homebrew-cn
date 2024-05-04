cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.1.0"
  sha256 arm:   "2837c011b2157d321a015ae64e8b3d0dcbfa4cc65f6d411038d12472753ac906",
         intel: "d8e98aa47d7a6b1b31b8a3f35accdfdca5c03db6ccc215e24c6494cfd3e91eb3"

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