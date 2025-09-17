cask "dbptk" do
  arch arm: "arm64", intel: "x64"

  version "3.1.7"
  sha256 arm:   "5a2617131f083bc85aaa0e8223ccf8a131d29b4d40f5c254219c12c7c41604cf",
         intel: "6b96be1a052a2466f6800d7c95fb87531ec375100d91491cdd3d6d0a5febec6b"

  url "https://ghfast.top/https://github.com/keeps/dbptk-desktop/releases/download/v#{version}/dbptk-desktop-#{version}-mac-#{arch}.dmg",
      verified: "github.com/keeps/dbptk-desktop/"
  name "Database Preservation Toolkit"
  desc "Set of tools to store relational databases in a standard archival format"
  homepage "https://database-preservation.com/"

  app "dbptk-desktop.app"
end