cask "znote" do
  arch arm: "-arm64"

  version "3.0.1"
  sha256 arm:   "4baa4ca8bff3f6644dd3c64132306153c3917a4a41a4f2460b41e2039ffb68ca",
         intel: "c0299044ac1d7af9292b1a2a8d40720cd5cb268493a05253f2482208e0d1c124"

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