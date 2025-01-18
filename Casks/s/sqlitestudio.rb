cask "sqlitestudio" do
  version "3.4.15"
  sha256 "6b546bb03cf8d82ccd35f34c4633cb79b53adfe50dfd3c31d8a0c89bbf38de07"

  url "https:github.compawelsalawasqlitestudioreleasesdownload#{version}sqlitestudio-#{version}-macos-x64.dmg",
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