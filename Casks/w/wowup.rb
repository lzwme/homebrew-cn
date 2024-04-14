cask "wowup" do
  arch arm: "-arm64"

  version "2.11.0"
  sha256 arm:   "7ea8b3bbcf554c3abfbb38fc5db89c4147f3d3f12068c2b0dbc32452f2c33412",
         intel: "90847e6dfe032d1a52e95f2397034fd119f4c0369bdbd90fe0a4c4b1ac9829ad"

  url "https:github.comWowUpWowUpreleasesdownloadv#{version}WowUp-#{version}#{arch}.dmg",
      verified: "github.comWowUpWowUp"
  name "WowUp"
  desc "World of Warcraft addon manager"
  homepage "https:wowup.io"

  auto_updates true

  app "WowUp.app"

  uninstall quit: "io.wowup.jliddev"

  zap trash: [
    "~LibraryApplication SupportWowUp",
    "~LibraryLogsWowUp",
    "~LibraryPreferencesio.wowup.jliddev.plist",
    "~LibrarySaved Application Stateio.wowup.jliddev.savedState",
  ]
end