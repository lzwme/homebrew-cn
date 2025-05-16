cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.1.2"
  sha256 arm:   "dbba1d067cdd13ff47a0b22f031420a48088f85bcdfceef119da009fe756e077",
         intel: "f91bc73cc23ec773c34eefb34ec660586a5f0eebc6c8ee43379d3bfdf095ca29"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end