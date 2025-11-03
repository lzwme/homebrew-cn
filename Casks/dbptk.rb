cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.3.0"
  sha256 arm:   "6ab54e70a6af174aa03754fef8b578f7b3c5316bf40499cbcf0f59acdfbbe885",
         intel: "2e910362b699af9e569915a1125415ff5d821af79a0b771a3a54e3979ee021c0"

  url "https://ghfast.top/https://github.com/keeps/dbptk-desktop/releases/download/v#{version}/dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.com/keeps/dbptk-desktop/"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https://database-preservation.com/"

  depends_on macos: ">= :big_sur"

  app "dbptk-desktop.app"
end