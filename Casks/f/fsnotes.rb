cask "fsnotes" do
  version "6.7.0"
  sha256 "98fe33dfd44caa55baa89a13000cb6a0acdf3d36d36e2c2f8e8d8c29bdc908a0"

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