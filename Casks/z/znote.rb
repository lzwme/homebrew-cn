cask "znote" do
  arch arm: "-arm64"

  version "2.5.3"
  sha256 arm:   "296c990546ffdbda6c09629312ea77923df3bca514d90513c019e5811c19c84e",
         intel: "db92f2fcdf919886408cadd8ae187c8ea3e4f5781ece94c05092803424aafd32"

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