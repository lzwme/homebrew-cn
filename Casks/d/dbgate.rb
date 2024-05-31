cask "dbgate" do
  version "5.2.9"
  sha256 "af273b883322c9c32ab6373474c92aa7b84d8c1e4e9a9a0c6bd2358c9708b033"

  url "https:github.comdbgatedbgatereleasesdownloadv#{version}dbgate-#{version}-mac_universal.dmg",
      verified: "github.comdbgatedbgate"
  name "DbGate"
  desc "Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others"
  homepage "https:dbgate.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "dbgate.app"

  zap trash: [
    "~dbgate-data",
    "~LibraryApplication Supportdbgate",
    "~LibraryLogsdbgate",
    "~LibraryPreferencesorg.dbgate.plist",
    "~LibrarySaved Application Stateorg.dbgate.savedState",
  ]
end