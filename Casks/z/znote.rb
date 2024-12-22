cask "znote" do
  arch arm: "-arm64"

  version "2.7.3"
  sha256 arm:   "07e6dab8e0aa726ad456b56d19f1483f3a488d89b0d0d66a9dc4ddb7b3f1379d",
         intel: "86c29822f48fdc62fb099b5be3264f87dfcaf1db9486f5b5ff4e140ae5f97d5f"

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