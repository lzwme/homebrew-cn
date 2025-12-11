cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.4.0"
  sha256 arm:   "86d13c0d44852ef992b0ece24fb6f839c5acac7f68e4c6454986df1c0f8c6c92",
         intel: "a88c5d7f1da58d6bf1213cebb66b0198dfe3d6714dd8a6ed9ddba1647599ae88"

  url "https://ghfast.top/https://github.com/keeps/dbptk-desktop/releases/download/v#{version}/dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.com/keeps/dbptk-desktop/"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https://database-preservation.com/"

  app "dbptk-desktop.app"
end