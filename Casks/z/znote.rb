cask "znote" do
  arch arm: "-arm64"

  version "3.0.8"
  sha256 arm:   "7fb9a9706450e69c274567dcf4917ea5a536a69d50410d330141c6505b33e3e8",
         intel: "472e8ae0396685e6db406944d6c3fde697553be0fd9a55b9cf8c56493efab7ea"

  url "https:github.comalagredeznote-appreleasesdownloadv#{version}znote-#{version}#{arch}.dmg",
      verified: "github.comalagredeznote-app"
  name "Znote"
  desc "Notes-taking app"
  homepage "https:znote.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "znote.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.tony.znote.sfl*",
    "~LibraryApplication Supportznote",
    "~LibraryPreferencescom.tony.znote.plist",
    "~LibrarySaved Application Statecom.tony.znote.savedState",
  ]
end