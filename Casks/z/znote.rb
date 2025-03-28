cask "znote" do
  arch arm: "-arm64"

  version "3.0.9"
  sha256 arm:   "a8725055ed69cac07ed99166ae261a41608e3f487d31f4e1e737d36836658757",
         intel: "0d6a69236453f5e90d427a7c38fa3c6b7059f0a8f3a9452ddaaecdf55907db84"

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