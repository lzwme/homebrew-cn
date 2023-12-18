cask "hot" do
  version "1.9.1"
  sha256 "2c104b0d9e9e6966abc2be33d8785050663cfe3dee1e3fa5fa3d8a3fb41dedd3"

  url "https:github.commacmadeHotreleasesdownload#{version}Hot.app.zip"
  name "Hot"
  desc "Menu bar application that displays the CPU speed limit due to thermal issues"
  homepage "https:github.commacmadeHot"

  auto_updates true

  app "Hot.app"

  zap trash: [
    "~LibraryCachescom.xs-labs.Hot",
    "~LibraryPreferencescom.xs-labs.Hot.plist",
  ]
end