cask "bossa" do
  version "1.9.1"
  sha256 "ef325525d2ce1fa6078732e5aa0c16cf78114bd3cf867016c4b948022d1cb31f"

  url "https:github.comshumatechBOSSAreleasesdownload#{version}bossa-#{version}.dmg",
      verified: "github.comshumatechBOSSA"
  name "bossa"
  homepage "https:www.shumatech.comwebproductsbossa"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-03", because: :unmaintained

  app "BOSSA.app"
  binary "bossac"
  binary "bossash"

  caveats do
    requires_rosetta
  end
end