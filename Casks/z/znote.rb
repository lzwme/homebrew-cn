cask "znote" do
  arch arm: "-arm64"

  version "2.4.8"
  sha256 arm:   "8bfc6a44cb28758d0c5fb39931e8de032e915fb6487057d188c088e34dc7af98",
         intel: "9d06f7ec8426dba9a72fed9f710dbdb65b96db2606c08d30d4b826e92c994693"

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