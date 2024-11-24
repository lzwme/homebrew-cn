cask "sqlitestudio" do
  version "3.4.6"
  sha256 "aae7f8ca567ca317416d9603651fdbca0876c68810bea3aa79bebce4612f15bf"

  url "https:github.compawelsalawasqlitestudioreleasesdownload#{version}sqlitestudio-#{version}.dmg",
      verified: "github.compawelsalawasqlitestudioreleasesdownload"
  name "SQLiteStudio"
  desc "Create, edit, browse SQLite databases"
  homepage "https:sqlitestudio.pl"

  app "SQLiteStudio.app"

  zap trash: [
    "~.configsqlitestudio",
    "~LibraryPreferencespl.com.salsoft.SQLiteStudio.plist",
    "~LibraryPreferencesSalSoftSQLiteStudio",
    "~LibrarySaved Application Statecom.yourcompany.SQLiteStudio.savedState",
    "~LibrarySaved Application Statepl.com.salsoft.SQLiteStudio.savedState",
  ]

  caveats do
    requires_rosetta
  end
end