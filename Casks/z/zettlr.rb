cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.4.0"
  sha256 arm:   "662a1db0785d306afbf471be15aa1b3f62316d9f49b81d2fe19e0496b3cb05b5",
         intel: "673a2e576393717370f8c12b43d3436178afd3bb22172bde3ee015abe693da68"

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