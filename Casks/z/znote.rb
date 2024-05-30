cask "znote" do
  arch arm: "-arm64"

  version "2.6.1"
  sha256 arm:   "65ae753e74ee71bccf54f502034ddb8f0f2cfe34a2e5622503320899d37f024e",
         intel: "b489f9ed2e056548391d2d1cea5f32f136ddd94847567a17d01ec91ec8f66b01"

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