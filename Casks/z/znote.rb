cask "znote" do
  arch arm: "-arm64"

  version "3.0.7"
  sha256 arm:   "9c8dd699ea457f14562f62e7e432bfd372b79a720b06fd780a84751c502bb6fc",
         intel: "3d0a76e90476afd3762b79cad5260d9a7304ec511b37e355f9eea87e9ddeb262"

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