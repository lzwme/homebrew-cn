cask "znote" do
  arch arm: "-arm64"

  version "3.0.6"
  sha256 arm:   "2281726da3e087b6077158a4bd6975c64529ee00a1653609f6a42a8adbbe2512",
         intel: "3589830e47caf00bdfb7e9547f631dd3f7052191f0dcf551c2bf28f3d5f57e57"

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