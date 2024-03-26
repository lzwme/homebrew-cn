cask "znote" do
  arch arm: "-arm64"

  version "2.5.5"
  sha256 arm:   "78012086edfe4c666f4c892703c8736817107738ed153dd92034e6175218a4d7",
         intel: "111aa932136b0cfbbc14bc6753d64343b0fa643a7a1211bfd485383ca78bd969"

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