cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.5.0"
  sha256 arm:   "e621c9ba6f1380ebd8a394ba6beeed94050d547b83ace921fe2290eff86c0cbd",
         intel: "dfc7bf780d3fd23f8acf63c8e39394c15941ff671ec47d61eafcea2713233cb6"

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