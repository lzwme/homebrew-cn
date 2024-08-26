cask "sqlitestudio" do
  version "3.4.4"
  sha256 "bd1bf5cd0e442b867ef9417e6c849d7b9f4d38f4305804c4b9d58d905092d8ef"

  url "https:github.compawelsalawasqlitestudioreleasesdownload#{version}SQLiteStudio-#{version}.dmg",
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