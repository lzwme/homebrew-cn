cask "znote" do
  arch arm: "-arm64"

  version "2.4.6"
  sha256 arm:   "0d7654cbb097f9a811e1180586fd2878cb5e3dff59240e55cf92e09d7eb6ac1e",
         intel: "47c4b902028c197c10b30188c91f227b74ca09772eaf68a48e7858c4412969a3"

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