cask "sqlitestudio" do
  version "3.4.16"
  sha256 "879f6e3a6cfa76bce2d65348870b686fec6162a7bb22619ebd7a28670dc6df07"

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