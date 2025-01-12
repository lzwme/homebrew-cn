cask "znote" do
  arch arm: "-arm64"

  version "2.7.8"
  sha256 arm:   "0522634bffa9991cca5debd0dbf84177030d80228c3ae797da766db296cf5a5e",
         intel: "0dba4a1e830972343d0a7527a9dd9cd41876838c5537f3609ca8c7b6c556f31f"

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