cask "znote" do
  arch arm: "-arm64"

  version "2.6.13"
  sha256 arm:   "42642fadcbfe7c6dea7a1ccc7d9aabc7df98d2f5748960be128c31697240d0d4",
         intel: "4f775f34512316be4d7abc8a6a6ea9cfdc48462c02c5d22a63a3203a68451da9"

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