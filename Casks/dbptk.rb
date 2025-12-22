cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.4.1"
  sha256 arm:   "c165b31d08112ee6b4e5480ef63f9c78f4a454952985a8f44914769e7b82e9d9",
         intel: "a958389ab5a4e4a345bf6c5b8c8b3b1e6369678bf7626b72369e5f140f195f08"

  url "https://ghfast.top/https://github.com/keeps/dbptk-desktop/releases/download/v#{version}/dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.com/keeps/dbptk-desktop/"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https://database-preservation.com/"

  depends_on macos: ">= :big_sur"

  app "dbptk-desktop.app"
end