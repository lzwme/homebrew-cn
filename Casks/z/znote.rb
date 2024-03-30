cask "znote" do
  arch arm: "-arm64"

  version "2.5.6"
  sha256 arm:   "26716cc7da3e87a3ca20e32a9e37a896b1a5873156313d38445f786a72967997",
         intel: "e025a839cfa5b0097a49a13133845dfd9b6804a8a2c0c0f6703a78d18a9b3d94"

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