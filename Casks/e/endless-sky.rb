cask "endless-sky" do
  version "0.10.6"
  sha256 "97aee28ba528a417852e408685d39c2bc7b1c555b942a1e3c7340cb540ee1f52"

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