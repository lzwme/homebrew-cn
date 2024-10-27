cask "exist-db" do
  version "6.3.0"
  sha256 "4cb5858e2f1f0e5b8e74217c9cea7d85c31292120883e672d87e636374b46412"

  url "https:github.comeXist-dbexistreleasesdownloadeXist-#{version}eXist-db-#{version}.dmg",
      verified: "github.comeXist-dbexist"
  name "eXist-db"
  desc "Native XML database and application platform"
  homepage "https:exist-db.orgexistappshomepageindex.html"

  app "eXist-db.app"

  zap trash: "~LibraryApplication Supportorg.exist"

  caveats do
    depends_on_java "8"
    requires_rosetta
  end
end