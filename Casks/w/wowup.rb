cask "wowup" do
  arch arm: "-arm64"

  version "2.10.0"
  sha256 arm:   "cbe35839240a592862169db6b0e4f77529eccb90d940c5ebfa29ad999c4f2fc6",
         intel: "006bb26c2556e564dd16942dd23bf167c688656e0b440fc08c5ebc7f734abb36"

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