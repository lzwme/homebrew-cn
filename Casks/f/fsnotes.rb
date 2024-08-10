cask "fsnotes" do
  version "6.9.1"
  sha256 "247940d64419a8bd0afe6461406ca3f401911a334bc180d11c95e2a3454c812b"

  url "https:github.comglushchenkofsnotesreleasesdownload#{version}FSNotes_#{version}.zip",
      verified: "github.comglushchenkofsnotes"
  name "FSNotes"
  desc "Notes manager"
  homepage "https:fsnot.es"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "FSNotes.app"

  zap trash: [
    "~LibraryApplication Scriptsco.fluder.FSNotes",
    "~LibraryContainersco.fluder.FSNotes",
  ]
end