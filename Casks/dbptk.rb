cask "dbptk" do
  version "2.9.2"
  sha256 "3eb682f0d320c796139d02c61e5d43ecae7deea523f71385264e98cd65964783"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end