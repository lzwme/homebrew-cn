cask "znote" do
  arch arm: "-arm64"

  version "2.6.6"
  sha256 arm:   "2db210d766b38665d04305c419d40ddd6b853a83ef974f2825d0e0a906c3baeb",
         intel: "219da304b787e085ea771a40ed468fde9a370426d37b42d5d302f977a6fa1400"

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