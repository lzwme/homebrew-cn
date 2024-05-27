cask "dbptk" do
  version "2.9.1"
  sha256 "4465191a1a8c9677a9f30db77f1b799eec2ede1e166d29b13af2c53c48a17c81"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end