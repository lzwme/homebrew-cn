cask "db-browser-for-sqlite@nightly" do
  version "20250608"
  sha256 "d56d949d87e7712982caa5e43d51e6292c7e1e8489e4566736a873d6a6b17695"

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

  app "DB Browser for SQLite Nightly.app"

  zap trash: [
    "~LibraryPreferencescom.sqlitebrowser.sqlitebrowser.plist",
    "~LibraryPreferencesnet.sourceforge.sqlitebrowser.plist",
    "~LibrarySaved Application Statenet.sourceforge.sqlitebrowser.savedState",
  ]
end