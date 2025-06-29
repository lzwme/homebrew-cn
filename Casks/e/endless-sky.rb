cask "endless-sky" do
  version "0.10.14"
  sha256 "f3c5ebdc901d9daee142f7dc3a92c13a942bedd6c578fff77bf289e5dbe48686"

  url "https:github.comendless-skyendless-skyreleasesdownloadv#{version}Endless-Sky-v#{version}.dmg",
      verified: "github.comendless-skyendless-sky"
  name "Endless Sky"
  desc "Space exploration, trading, and combat game"
  homepage "https:endless-sky.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Endless Sky.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsendless-sky.sfl",
    "~LibraryApplication Supportendless-sky",
    "~LibrarySaved Application StateEndless-Sky.savedState",
  ]
end