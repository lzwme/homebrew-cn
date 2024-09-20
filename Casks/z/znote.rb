cask "znote" do
  arch arm: "-arm64"

  version "2.6.5"
  sha256 arm:   "3a28dba75eecfaab71b05e401910e5428baafa0c376aa83d6834ba41f32e794f",
         intel: "58bc0e40c8113ecc420a0ca92daef20bf50b22c62a26ccec038d2d16dc9564e1"

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