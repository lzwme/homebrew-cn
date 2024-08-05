cask "fsnotes" do
  version "6.9.0"
  sha256 "612b871a8af25ec55136d71589418795c710e9b5e45a49506c8d5cbde42c572c"

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