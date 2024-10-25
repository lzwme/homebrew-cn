cask "znote" do
  arch arm: "-arm64"

  version "2.6.7"
  sha256 arm:   "754b60287036e6f3b3094bd5ce8aaf4b7e2475fac99b2524bb1e4f149798cc20",
         intel: "36dda60330074fcd9251cd33ecc2fb68a2de1c613ac68d8d4b10ddbc1ebea0aa"

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