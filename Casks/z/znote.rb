cask "znote" do
  arch arm: "-arm64"

  version "2.7.4"
  sha256 arm:   "3bdcd36b7209eed2e5fe1346d91faa690d8e9050995747a59530aca1efabdb60",
         intel: "60b227d0a064b02a28fbb0ec4f484b5193c042aa48cb18f122c4912475ab7558"

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