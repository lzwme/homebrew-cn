cask "znote" do
  arch arm: "-arm64"

  version "2.7.7"
  sha256 arm:   "60189e8c957d2fe4fc3488b87e681bb2e9a344b08ab6aecad3eed5d04153c2d7",
         intel: "e3926da7e7c317e6ddc3b375f31f2d5657037efd5e2b2b866c77e052d02958d8"

  url "https:github.comalagredeznote-appreleasesdownloadv#{version}znote-#{version}#{arch}.dmg",
      verified: "github.comalagredeznote-app"
  name "Znote"
  desc "Notes-taking app"
  homepage "https:znote.io"

  depends_on macos: ">= :catalina"

  app "znote.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.tony.znote.sfl*",
    "~LibraryApplication Supportznote",
    "~LibraryPreferencescom.tony.znote.plist",
    "~LibrarySaved Application Statecom.tony.znote.savedState",
  ]
end