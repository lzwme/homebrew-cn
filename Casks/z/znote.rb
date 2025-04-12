cask "znote" do
  arch arm: "-arm64"

  version "3.1.3"
  sha256 arm:   "482fa85d5a014966c08fbb7cf274bfb3a2e3dd97371dfd4db046e588e44612f2",
         intel: "0971da8df87c6a679faf84ef9ee17d1438118c5c45ee2c5f3d6b205843870a4c"

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