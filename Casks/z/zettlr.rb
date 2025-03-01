cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.4.3"
  sha256 arm:   "49ebf751063beb35fbbb54b39c734bdac82feb11296247749605904f8a4d755e",
         intel: "54546532b1bb2b42f5ca0245fe36fbd7c5d56f0af5c631b4123bc55d3780d5c2"

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