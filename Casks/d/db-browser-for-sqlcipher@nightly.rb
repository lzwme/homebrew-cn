cask "db-browser-for-sqlcipher@nightly" do
  version "20250608"
  sha256 "78a58c22eb75fe0d3aba91b341670669117bcf2d850bd8cce5906873b7a5bbdb"

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