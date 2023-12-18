cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.0.3"
  sha256 arm:   "0f4e45815309223623d3a5b798b12014dd71d77144a978f13b3f2ea7fcf63aa0",
         intel: "e7ec0ecb50917c155308cf67606f22b46e39c08c25a115d487626d310af08114"

  url "https:github.comZettlrZettlrreleasesdownloadv#{version}Zettlr-#{version}-#{arch}.dmg"
  name "Zettlr"
  desc "Open-source markdown editor"
  homepage "https:github.comZettlrZettlr"

  depends_on macos: ">= :high_sierra"

  app "Zettlr.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.zettlr.app.sfl*",
    "~LibraryApplication Supportzettlr",
    "~LibraryLogsZettlr",
    "~LibraryPreferencescom.zettlr.app.plist",
    "~LibrarySaved Application Statecom.zettlr.app.savedState",
  ]
end