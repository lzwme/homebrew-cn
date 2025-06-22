cask "db-browser-for-sqlcipher@nightly" do
  version "20250621"
  sha256 "28cb9d4f0894e3cfa73714ba3a5942e5f6a670545c9c3ed250580f7e10923ac6"

  url "https:github.comsqlitebrowsersqlitebrowserreleasesdownloadnightlyDB.Browser.for.SQLCipher-universal_#{version}.dmg",
      verified: "github.comsqlitebrowsersqlitebrowser"
  name "DB Browser for SQLCipher Nightly"
  desc "Database browser for SQLCipher"
  homepage "https:sqlitebrowser.org"

  livecheck do
    cask "db-browser-for-sqlite@nightly"
    regex(^DB[._-]Browser[._-]for[._-]SQLCipher[._-]universal[._-]v?(\d+(?:\.\d+)*)\.dmgi)
  end

  no_autobump! because: :requires_manual_review

  app "DB Browser for SQLCipher Nightly.app"

  zap trash: [
    "~LibraryPreferencescom.sqlitebrowser.sqlitebrowser.plist",
    "~LibraryPreferencesnet.sourceforge.sqlitebrowser.plist",
    "~LibrarySaved Application Statenet.sourceforge.sqlitebrowser.savedState",
  ]
end