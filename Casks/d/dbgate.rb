cask "dbgate" do
  version "6.5.1"
  sha256 "f5e4b325ac232e9fec11056fe54f9fb66ca1773dc64507b8f0be0cecb16dcdc6"

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