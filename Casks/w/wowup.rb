cask "wowup" do
  arch arm: "-arm64"

  version "2.20.0"
  sha256 arm:   "3da6069b9dec9478ccaf6bf3ecb0363c4dbb8106c02f96c295d1f263a5dc18ae",
         intel: "6fae75ce3ecfccfe2ea4ed74ced97da06b10abbca6e79c0a4f61a12592953ed7"

  url "https:github.comWowUpWowUpreleasesdownloadv#{version}WowUp-#{version}#{arch}.dmg",
      verified: "github.comWowUpWowUp"
  name "WowUp"
  desc "World of Warcraft addon manager"
  homepage "https:wowup.io"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "WowUp.app"

  uninstall quit: "io.wowup.jliddev"

  zap trash: [
    "~LibraryApplication SupportWowUp",
    "~LibraryLogsWowUp",
    "~LibraryPreferencesio.wowup.jliddev.plist",
    "~LibrarySaved Application Stateio.wowup.jliddev.savedState",
  ]
end