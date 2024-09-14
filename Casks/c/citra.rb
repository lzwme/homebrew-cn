cask "citra" do
  version "2.0"
  sha256 "ecfdcfb89b8c961fe1b68313121d2af37370b43af38e9bcd16cccc162ab121ec"

  url "https:github.comcitra-emucitra-webreleasesdownload#{version}citra-setup-mac.dmg",
      verified: "github.comcitra-emucitra-web"
  name "Citra"
  desc "Nintendo 3DS emulator"
  homepage "https:citra-emu.org"

  deprecate! date: "2024-06-25", because: :discontinued

  installer manual: "citra-setup-mac.app"

  uninstall delete: "ApplicationsCitra"

  zap trash: [
    "~LibraryPreferencescom.citra-emu.citra.plist",
    "~LibrarySaved Application Statecom.citra-emu.citra.savedState",
  ]
end