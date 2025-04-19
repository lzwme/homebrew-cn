cask "znote" do
  arch arm: "-arm64"

  version "3.1.7"
  sha256 arm:   "05254e8c6913898ba04a7eee1070cdfdfe27115018f908e3bc018381d0bc27bf",
         intel: "595e0902fdde029bfaa0dec8953e9af26b7f5998309de1cc72a2bf84902d38d6"

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