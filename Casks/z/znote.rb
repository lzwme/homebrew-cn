cask "znote" do
  arch arm: "-arm64"

  version "2.4.7"
  sha256 arm:   "93b907cf3084aa21ef0661c72abf8741bc292e7733d72f25c394f88ab639e61b",
         intel: "82114844c0f2d2096135576c62ca030c59585429bca30e4d34305fcfffa8e5bb"

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