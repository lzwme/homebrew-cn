cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.1.5"
  sha256 arm:   "827b834616b7794e33ef82786a7b9aa2f09a75ad0c169e9fb9adbe6433d19295",
         intel: "d945b859696593e3847bcd79dbcebc069de19e56c0a6f2440d3b76b8b4a42789"

  url "https://ghfast.top/https://github.com/keeps/dbptk-desktop/releases/download/v#{version}/dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.com/keeps/dbptk-desktop/"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https://database-preservation.com/"

  app "dbptk-desktop.app"
end