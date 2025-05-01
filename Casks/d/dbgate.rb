cask "dbgate" do
  version "6.4.0"
  sha256 "992b919390a3396d449a6c8169b829a17d09eb05929ac787d492b6a40667797b"

  url "https:github.comdbgatedbgatereleasesdownloadv#{version}dbgate-#{version}-mac_universal.dmg",
      verified: "github.comdbgatedbgate"
  name "DbGate"
  desc "Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others"
  homepage "https:dbgate.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "DbGate.app"

  zap trash: [
    "~dbgate-data",
    "~LibraryApplication Supportdbgate",
    "~LibraryLogsdbgate",
    "~LibraryPreferencesorg.dbgate.plist",
    "~LibrarySaved Application Stateorg.dbgate.savedState",
  ]
end