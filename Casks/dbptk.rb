cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.1.0"
  sha256 arm:   "357e8064c718155fa15a01a2b0ed549030f6654951bc9a4beb67bdd8b21f215a",
         intel: "fa7edbdb37ffe75a0f771268203fd2723aa1afbead16e0c6c38ded1144c5a390"

  url "https:github.comkeepsdbptk-desktopreleasesdownloadv#{version}dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.comkeepsdbptk-desktop"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https:database-preservation.com"

  app "dbptk-desktop.app"
end