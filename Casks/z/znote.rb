cask "znote" do
  arch arm: "-arm64"

  version "2.6.11"
  sha256 arm:   "fa484e88e4973993b3eb69d6be5f295ac1e95868dd0f231eeafb9df8904988da",
         intel: "0250b104af0b70e6e15a0633a1473d3f2e570556ff9114b4f72fd348275efa5b"

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