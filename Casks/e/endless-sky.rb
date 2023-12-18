cask "endless-sky" do
  version "0.10.4"
  sha256 "d450d75788bf07573a0812f383af12a90ec5e0101e989d4c9bf0e9e736e7f8d5"

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