cask "znote" do
  arch arm: "-arm64"

  version "3.1.0"
  sha256 arm:   "3fa8abfb20d53cadf84400df4ce231978ced0879bdd7c2fa60d208b6a9697bd6",
         intel: "bb915ffc4edbf86f731f7d49c167fa7cb5fda3a385565411ec04c2fd9c48cf0f"

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