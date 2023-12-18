cask "dbptk" do
  version "2.7.1"
  sha256 "26390e6199f234f215118aa79875a99069b0533ba44a757aa62e0ee92bea5bdf"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end