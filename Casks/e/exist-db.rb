cask "exist-db" do
  version "6.4.0"
  sha256 "96eb36111abc43786536a26de6437b2e675bf7ae4780633d37d832b0fe6c28c2"

  url "https:github.comeXist-dbexistreleasesdownloadeXist-#{version}eXist-db-#{version}.dmg",
      verified: "github.comeXist-dbexist"
  name "eXist-db"
  desc "Native XML database and application platform"
  homepage "https:exist-db.orgexistappshomepageindex.html"

  no_autobump! because: :requires_manual_review

  app "eXist-db.app"

  zap trash: "~LibraryApplication Supportorg.exist"

  caveats do
    depends_on_java "8"
  end
end