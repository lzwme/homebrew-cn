cask "postgrespreferencepane" do
  version "2.7"
  sha256 "970510169d0e37fb3feca6fa700d26fa2421aabcd19fc17db58eb0dca89ebb14"

  url "https:github.comMaccaTechPostgresPrefsreleasesdownloadv#{version}PostgresPrefs-v#{version}.dmg"
  name "PostgresPrefs"
  desc "Preference Pane for controlling PostgreSQL database servers"
  homepage "https:github.comMaccaTechPostgresPrefs"

  prefpane "PostgreSQL.prefPane"

  zap trash: [
    "~LibraryLaunchAgentsorg.postgresql.preferences.*.plist",
    "~LibraryLogsPostgreSQL",
    "~LibraryPreferencesorg.postgresql.preferences.servers.plist",
  ]
end