cask "znote" do
  arch arm: "-arm64"

  version "2.5.2"
  sha256 arm:   "5acdb8720e5b81d5ee30516390f62e6f4a873dfdcf95b3c1669dfa195f9855db",
         intel: "544bcae6bfd6dfcf8776d6585c35ec6ea8fff1ef35d80546fcbf9734c9670210"

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