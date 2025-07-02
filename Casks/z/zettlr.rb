cask "zettlr" do
  arch arm: "arm64", intel: "x64"

  version "3.5.1"
  sha256 arm:   "0c3013f1e54156094b55515b9413c82fce5d8e57dfea8176db91708940acc9cc",
         intel: "8d5e3959e08bd46cedcf51967ee2b5d334850036764bb8e5681ac128e548ae4e"

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