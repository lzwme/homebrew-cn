cask "fsnotes" do
  version "6.9.10"
  sha256 "861a281f1d1f0a1c923cf38dd9b1ea4613aa81114016b49fc36354be4b9046ba"

  url "https:github.comglushchenkofsnotesreleasesdownload#{version}FSNotes_#{version}.zip",
      verified: "github.comglushchenkofsnotes"
  name "FSNotes"
  desc "Notes manager"
  homepage "https:fsnot.es"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  app "FSNotes.app"

  zap trash: [
    "~LibraryApplication Scriptsco.fluder.FSNotes",
    "~LibraryContainersco.fluder.FSNotes",
  ]
end