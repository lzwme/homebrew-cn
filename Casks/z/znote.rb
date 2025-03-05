cask "znote" do
  arch arm: "-arm64"

  version "3.0.3"
  sha256 arm:   "3ecfa8ee6456b06d8d3e4eed1f611f8e28daa3142ec3c69a67f650172585320f",
         intel: "18b5bae12b6526fbb4b9f4a2f2021f92ecf8c59237f8b4c3ab4fd06d2c04f4db"

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