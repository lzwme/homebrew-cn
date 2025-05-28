cask "znote" do
  arch arm: "-arm64"

  version "3.2.1"
  sha256 arm:   "aaf72396ebc9cd5a208c5c278240b9d51284288fee7fb8497500c39b109acdc8",
         intel: "d7049088a8739e7af0351a43f21281bb5ca1c002f3531b602a9c19248b469653"

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