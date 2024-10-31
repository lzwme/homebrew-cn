cask "znote" do
  arch arm: "-arm64"

  version "2.6.8"
  sha256 arm:   "7d564b44cd63d574d723739863da30250c41f048240a046734a19063cdde9ac3",
         intel: "d627490f881d0831278f2034a5b9b738990a0587b3cc005e7d02aebdd4b2ee6a"

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