cask "db-browser-for-sqlite@nightly" do
  version "20250621"
  sha256 "908d3f38905a0d817d137e0ae091072551a15f2d5654e7d81bd2264caa0b7f01"

  url "https:github.comsqlitebrowsersqlitebrowserreleasesdownloadnightlyDB.Browser.for.SQLite-universal_#{version}.dmg",
      verified: "github.comsqlitebrowsersqlitebrowser"
  name "DB Browser for SQLite Nightly"
  desc "Database browser for SQLite"
  homepage "https:sqlitebrowser.org"

  livecheck do
    url :url
    regex(^DB[._-]Browser[._-]for[._-]SQLite[._-]universal[._-]v?(\d+(?:\.\d+)*)\.dmgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["tag_name"] != "nightly"
        next if release["draft"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  no_autobump! because: :requires_manual_review

  app "DB Browser for SQLite Nightly.app"

  zap trash: [
    "~LibraryPreferencescom.sqlitebrowser.sqlitebrowser.plist",
    "~LibraryPreferencesnet.sourceforge.sqlitebrowser.plist",
    "~LibrarySaved Application Statenet.sourceforge.sqlitebrowser.savedState",
  ]
end