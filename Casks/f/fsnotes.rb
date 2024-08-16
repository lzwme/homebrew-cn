cask "fsnotes" do
  version "6.9.2"
  sha256 "8c071c750012aad41d2b4ec4917a098e23c3b1191cca839c1650a8319d233f57"

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