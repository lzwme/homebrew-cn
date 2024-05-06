cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.1.1"
  sha256 arm:   "f56c5ac73922359f7af4cea63ed7aafc4e58be081014e7a5923ec4175f1ca461",
         intel: "3644b861dcf66889f85f71e27ebd789f9a33451a0437ae7e54b3347b73762642"

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