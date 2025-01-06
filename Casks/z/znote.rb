cask "znote" do
  arch arm: "-arm64"

  version "2.7.6"
  sha256 arm:   "37b850937ce68d27d3b15a265e73d812e177e30423707cb5394b652261eaebfc",
         intel: "9918bddfb9dda4b21757689f1f1d146ee710fa864c483db86079b7dbd3d7ece9"

  url "https:github.comalagredeznote-appreleasesdownloadv#{version}znote-#{version}#{arch}.dmg",
      verified: "github.comalagredeznote-app"
  name "Znote"
  desc "Notes-taking app"
  homepage "https:znote.io"

  depends_on macos: ">= :catalina"

  app "znote.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.tony.znote.sfl*",
    "~LibraryApplication Supportznote",
    "~LibraryPreferencescom.tony.znote.plist",
    "~LibrarySaved Application Statecom.tony.znote.savedState",
  ]
end