cask "znote" do
  arch arm: "-arm64"

  version "2.7.1"
  sha256 arm:   "8bd3f68a065dd6734222972e1e0301d406cc676ec7e377eee7f6021282454c44",
         intel: "360a85f4342f28e0814ff663cce312ffea11995c6b4535488bb7c7875ca3f9e6"

  url "https:github.comalagredeznote-appreleasesdownloadv#{version}znote-#{version}#{arch}.dmg",
      verified: "github.comalagredeznote-app"
  name "Znote"
  desc "Notes-taking app"
  homepage "https:znote.io"

  depends_on macos: ">= :el_capitan"

  app "znote.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.tony.znote.sfl*",
    "~LibraryApplication Supportznote",
    "~LibraryPreferencescom.tony.znote.plist",
    "~LibrarySaved Application Statecom.tony.znote.savedState",
  ]
end