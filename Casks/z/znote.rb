cask "znote" do
  arch arm: "-arm64"

  version "3.2.3"
  sha256 arm:   "96e5652862c0be20dcf00211b162095a108e557aa024ea3e4b9ab4e386e899be",
         intel: "f42b001b1d0af5b7f446f78f9ed47ff989221f6d02501e761af38ecd82539f7c"

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