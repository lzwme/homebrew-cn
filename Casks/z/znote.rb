cask "znote" do
  arch arm: "-arm64"

  version "2.4.3"
  sha256 arm:   "d331bd768421500b705af94a182726b041ed9c9ba517d60d47b9dec4b9582d85",
         intel: "9bc5067b5aaeef93884a7355702c5b4a51da43c5da76331352512eda382543c7"

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