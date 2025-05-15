cask "dbgate" do
  version "6.4.2"
  sha256 "c960dc217ac3f39aabfb3c79b1bb5c8b5630fc2ea05235bb34d8dfbbfb0295ab"

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