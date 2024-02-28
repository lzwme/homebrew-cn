cask "znote" do
  arch arm: "-arm64"

  version "2.5.0"
  sha256 arm:   "6bd5c9aa6e2aeaa2f9909592461a67cd2257c27553775724458d8c0c61ebafb6",
         intel: "4428dd1c19017451b4cabe49268c2eb8444d4a3581512778c088c5444ddd7ba0"

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