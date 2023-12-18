cask "hovrly" do
  version "2.4.5"
  sha256 "2cd4d3fc696a7a59446fea3c0a1d9f77b23cfed8bcd53c6992ffb5dc78711b88"

  url "https:github.comtarutinhovrlyreleasesdownloadv#{version}Hovrly-#{version}-universal.dmg",
      verified: "github.comtarutinhovrly"
  name "Hovrly"
  desc "Display and convert timezones time in different cities"
  homepage "https:hovrly.com"

  app "Hovrly.app"

  zap trash: [
    "~LibraryApplication SupportHovrly",
    "~LibraryPreferencescom.treasy.hovrly.plist",
    "~LibrarySaved Application Statecom.treasy.hovrly.savedState",
  ]
end