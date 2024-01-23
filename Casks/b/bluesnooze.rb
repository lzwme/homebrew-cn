cask "bluesnooze" do
  version "1.2"
  sha256 "075a8b7cf8f66d4f4002c62a1985a5d3fb043e3df09e7fd405e88ce24a96feb0"

  url "https:github.comodlpbluesnoozereleasesdownloadv#{version}Bluesnooze.zip"
  name "Bluesnooze"
  desc "Prevents your sleeping computer from connecting to Bluetooth accessories"
  homepage "https:github.comodlpbluesnooze"

  depends_on macos: ">= :monterey"

  app "Bluesnooze.app"

  zap trash: [
    "~LibraryApplication Scriptscom.oliverpeate.Bluesnooze",
    "~LibraryApplication Scriptscom.oliverpeate.Bluesnooze-LaunchAtLoginHelper",
    "~LibraryApplication SupportBluesnooze",
    "~LibraryContainerscom.oliverpeate.Bluesnooze",
    "~LibraryContainerscom.oliverpeate.Bluesnooze-LaunchAtLoginHelper",
    "~LibraryPreferencescom.oliverpeate.Bluesnooze.plist",
  ]
end