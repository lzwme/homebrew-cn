cask "dbptk" do
  version "2.8.0"
  sha256 "422ebad853bc4b13a5989d3834388c0859102a485edbcb776e44b2402cf35d60"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end