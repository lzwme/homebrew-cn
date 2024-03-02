cask "znote" do
  arch arm: "-arm64"

  version "2.5.1"
  sha256 arm:   "da9548616ba2b325f65cf166c2bfd4cac58e502ad5271ba3bfee8f518f56f0e8",
         intel: "046b1171452971ffa23cc48cfaef756847fe39f464cddd05e5792148dce819c7"

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