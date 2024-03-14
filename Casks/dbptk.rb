cask "dbptk" do
  version "2.9.0"
  sha256 "c1ea191a0a431a7270bec97b2239ccbd4c87cd36fd31dd271d0573480f4a2d21"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end