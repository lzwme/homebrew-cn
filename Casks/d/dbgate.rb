cask "dbgate" do
  version "6.1.2"
  sha256 "505bd69f17f866bee1092b9f30cd7c7addf6a79a179dca3b75e15ba674bcc03b"

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