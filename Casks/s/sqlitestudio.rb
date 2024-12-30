cask "sqlitestudio" do
  version "3.4.13"
  sha256 "c78cc98cdd371435dff3d541c69826135c10f511a373faf7f674ad425b5cb765"

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