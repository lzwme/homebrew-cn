cask "znote" do
  arch arm: "-arm64"

  version "2.4.9"
  sha256 arm:   "c1eab74debdcb47453f49567c57f8f24e7f4c27484e854b4e4ebd4f2528795a0",
         intel: "dc5a80607f8af4295648a3e22635d160208ee29c647aebcc41ccd34b8f6e289f"

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