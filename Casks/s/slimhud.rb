cask "slimhud" do
  version "1.5.1"
  sha256 "aecd074d2b2a98645a3136cb870e3e9f57fca903e36fc9e9b406049258ffe362"

  url "https:github.comAlexPerathonerSlimHUDreleasesdownloadv#{version}SlimHUD.zip"
  name "SlimHUD"
  desc "Replacement for the volume, brightness and keyboard backlight HUDs"
  homepage "https:github.comAlexPerathonerSlimHUD"

  depends_on macos: ">= :high_sierra"

  app "SlimHUD.app"

  zap trash: "~LibraryPreferencescom.alexpera.SlimHUD.plist"
end