cask "znote" do
  arch arm: "-arm64"

  version "2.4.5"
  sha256 arm:   "aa3941a61f2090c81d7f85db7c39cba00b6a3ee51c89659ce6a712b1f18ecadc",
         intel: "3835eaa60f03289f2fd011b8f9b5a9567eb368f7b122fbcae2cf2a3388869e35"

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