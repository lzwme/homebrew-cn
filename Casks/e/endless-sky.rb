cask "endless-sky" do
  version "0.10.12"
  sha256 "17495556de30d5c6c8381dc365b7ce159aebac8c7e39eadeb90d23080fb5fa9b"

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