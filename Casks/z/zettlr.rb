cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.2.2"
  sha256 arm:   "68ef933b6a05faebbb36a9da5ebd4e1d66187902816cdf1301ab6b58c03e96be",
         intel: "cfd5665029ab208edcfdcecf45de78366a0c34b3a67451ba2dc2c7a164fa86b7"

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