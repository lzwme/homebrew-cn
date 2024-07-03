cask "znote" do
  arch arm: "-arm64"

  version "2.6.4"
  sha256 arm:   "14e187bfa841871f5925c8eee59ebcec62e48f4b81a20c566ddace50f6ab1dba",
         intel: "9397837d7520590ff3dbb43058acdd6e6aebd7871ac3a7b6634ca140bbbf9c40"

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