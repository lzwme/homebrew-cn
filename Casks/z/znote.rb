cask "znote" do
  arch arm: "-arm64"

  version "2.6.9"
  sha256 arm:   "3970e0035817cf50eb41a2de7e97879a391b053449a11d98792f97109b87464a",
         intel: "0d1d39193b930dd9bf487916f7e51ebcd1b5cb40067eb4a7a674e957cf81badb"

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