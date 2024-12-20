cask "znote" do
  arch arm: "-arm64"

  version "2.7.2"
  sha256 arm:   "fee5af8981161046b5352c8bdd9ad463a5c5d3aa8931c9ec0c1f6be5929e69d0",
         intel: "0d97bee98ddff1c3b60eda22ed16b3e0b59c235ae3e64a32b101ee1175812517"

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