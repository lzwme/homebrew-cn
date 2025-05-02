cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.1.1"
  sha256 arm:   "9704093d71208e63efc4675a7eadcce13069fe77c0a7c98f0f5176abfa9b9ce2",
         intel: "03152e5d14567b9418ee656000c8b472801b98b4ae341f888162f5473dd4ca9e"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end