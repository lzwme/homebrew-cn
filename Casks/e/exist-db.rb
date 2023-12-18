cask "exist-db" do
  version "6.2.0"
  sha256 "2c127058c4effe54bbdd9655bc94fbafd326a38ea39e0f538bb8ed44359dd48d"

  url "https:github.comeXist-dbexistreleasesdownloadeXist-#{version}eXist-db-#{version}.dmg",
      verified: "github.comeXist-dbexist"
  name "eXist-db"
  desc "Native XML database and application platform"
  homepage "https:exist-db.orgexistappshomepageindex.html"

  app "eXist-db.app"

  zap trash: "~LibraryApplication Supportorg.exist"

  caveats do
    depends_on_java "8"
  end
end