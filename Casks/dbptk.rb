cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.0.2"
  sha256 arm:   "6fefd88dd1ae253f47b0d1648ff8e17f92319bc46d86d2c73bdb05cf48ab4303",
         intel: "58198d4f0935b3639c24532c2643603ae2af26aa1431510c745c55837acff482"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end