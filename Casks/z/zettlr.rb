cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.4.1"
  sha256 arm:   "e8ea818a9df52a841fe6a2f9197f11866d8e96afb2105c4c71c792ad1bd119e8",
         intel: "bc5d553243b2cd63b280f13b3d0069ae66cf4a6e6f305fd8828813650bd8e79a"

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