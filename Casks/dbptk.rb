cask "dbptk" do
  version "2.10.0"
  sha256 "a586cae45c40c9d82bc85e27d9edb563e0ddb46ce4c96d48b4e5fabc964b592c"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end