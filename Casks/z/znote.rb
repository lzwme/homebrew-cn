cask "znote" do
  arch arm: "-arm64"

  version "2.4.2"
  sha256 arm:   "f16c7f4ec28438758e4e24aebd2be3ed3195a4737fda36c36b6fc01f6155279b",
         intel: "5650a678d546b328ab22044b6b8222bd5cb6768e7e3580e92069b698a4930194"

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